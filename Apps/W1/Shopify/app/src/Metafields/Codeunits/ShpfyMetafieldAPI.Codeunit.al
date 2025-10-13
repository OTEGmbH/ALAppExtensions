namespace OTE.Shopify;

using OTE.Shopify;

codeunit 88238 "Shpfy Metafield API"
{
    Access = Internal;

    var
        Shop: Record "Shpfy Shop";
        JsonHelper: Codeunit "Shpfy Json Helper";
        CommunicationMgt: Codeunit "Shpfy Communication Mgt.";
        G_ShpfyMetafield: Record "Shpfy Metafield";
        G_MetafieldViewSet: boolean;


    internal procedure SetShop(ShopifyShop: Record "Shpfy Shop")
    begin
        Shop := ShopifyShop;
        CommunicationMgt.SetShop(Shop);
    end;

    #region To Shopify
    /// <summary>
    /// Creates or updates the metafields in Shopify.
    /// </summary>
    /// <remarks>
    /// Only metafields that have been updated in BC since last update in Shopify will be updated.
    /// MetafieldSet mutation only accepts 25 metafields at a time, so the function will create multiple queries if needed.
    /// </remarks>
    /// <param name="ParentTableId"></param>
    /// <param name="OwnerId"></param>
    internal procedure CreateOrUpdateMetafieldsInShopify(ParentTableId: Integer; OwnerId: BigInteger)
    var
        TempMetafieldSet: Record "Shpfy Metafield" temporary;
        MetafieldIds: Dictionary of [BigInteger, DateTime];
        Continue: Boolean;
        Count: Integer;
        GraphQuery: TextBuilder;
    begin
        //OTE Update marked Metafields 28.08.2025 JR START

        if (G_MetafieldViewSet) and (G_ShpfyMetafield.GetFilters <> '') then begin
            if G_ShpfyMetafield.findset(false) then
                repeat
                    TempMetafieldSet := G_ShpfyMetafield;
                    TempMetafieldSet.Insert(false);
                until G_ShpfyMetafield.Next() = 0;
            //OTE Update marked Metafields 28.08.2025 JR STOP 
        end else begin
            MetafieldIds := RetrieveMetafieldsFromShopify(ParentTableId, OwnerId);
            //OTE Auto Update Metafields by mapping 10.07.2025 JR START
            OnAfterRetrieveMetafieldsFromShopify(ParentTableId, OwnerId, MetafieldIds);
            //OTE Auto Update Metafields by mapping 10.07.2025 JR STOP 
            CollectMetafieldsInBC(ParentTableId, OwnerId, TempMetafieldSet, MetafieldIds);
        end;

        // MetafieldsSet mutation only accepts 25 metafields at a time
        Continue := true;
        if TempMetafieldSet.FindSet() then
            while Continue do begin
                Count := 0;
                Continue := false;
                GraphQuery.Clear();

                repeat
                    if Count = GetMaxMetafieldsToUpdate() then begin
                        Continue := true;
                        Clear(Count);
                        break;
                    end;

                    CreateMetafieldQuery(TempMetafieldSet, GraphQuery);
                    Count += 1;
                until TempMetafieldSet.Next() = 0;

                UpdateMetafields(GraphQuery.ToText());
            end;
    end;

    //OTE JR 28.08.2025 JR START
    procedure SetMetafieldFilterView(var _ShpfyMetafield: Record "Shpfy Metafield")
    begin
        G_ShpfyMetafield.Copy(_ShpfyMetafield);
        G_MetafieldViewSet := true;
    end;
    //OTE JR 28.08.2025 JR STOP 

    local procedure GetMaxMetafieldsToUpdate(): Integer
    begin
        exit(25);
    end;

    local procedure RetrieveMetafieldsFromShopify(ParentTableId: Integer; OwnerId: BigInteger): Dictionary of [BigInteger, DateTime]
    var
        Metafield: Record "Shpfy Metafield";
        IMetafieldOwnerType: Interface "Shpfy IMetafield Owner Type";
    begin
        IMetafieldOwnerType := Metafield.GetOwnerType(ParentTableId);
        exit(IMetafieldOwnerType.RetrieveMetafieldIdsFromShopify(OwnerId));
    end;

    local procedure CollectMetafieldsInBC(ParentTableId: Integer; OwnerId: BigInteger; var TempMetafieldSet: Record "Shpfy Metafield" temporary; MetafieldIds: Dictionary of [BigInteger, DateTime])
    var
        Metafield: Record "Shpfy Metafield";
        UpdatedAt: DateTime;
    begin
        Metafield.SetRange("Parent Table No.", ParentTableId);
        Metafield.SetRange("Owner Id", OwnerId);
        Metafield.SetFilter(Type, '<>%1&<>%2', Metafield.Type::string, Metafield.Type::integer);
        Metafield.SetFilter(Value, '<>%1', '');
        if Metafield.FindSet() then
            repeat
                if MetafieldIds.Get(Metafield.Id, UpdatedAt) then begin
                    if Metafield."Last Updated by BC" > UpdatedAt then begin
                        TempMetafieldSet := Metafield;
                        TempMetafieldSet.Insert(false);
                    end;
                end else begin
                    TempMetafieldSet := Metafield;
                    TempMetafieldSet.Insert(false);
                end;
            until Metafield.Next() = 0;
    end;

    /// <summary>
    /// Updates the metafields in Shopify.
    /// </summary>
    /// <param name="MetafieldsQuery">GraphQL query for the metafields.</param>
    internal procedure UpdateMetafields(MetafieldsQuery: Text) JResponse: JsonToken
    var
        Parameters: Dictionary of [Text, Text];
    begin
        Parameters.Add('Metafields', MetafieldsQuery);
        JResponse := CommunicationMgt.ExecuteGraphQL(Enum::"Shpfy GraphQL Type"::MetafieldSet, Parameters);
    end;

    /// <summary>
    /// Creates a GraphQL query for a metafield.
    /// </summary>
    /// <param name="MetafieldSet">Metafield record to create the query for.</param>
    /// <param name="GraphQuery">Return value: TextBuilder to append the query to.</param>
    internal procedure CreateMetafieldQuery(MetafieldSet: Record "Shpfy Metafield"; GraphQuery: TextBuilder)
    begin
        GraphQuery.Append('{');
        GraphQuery.Append('key: \"');
        GraphQuery.Append(MetafieldSet.Name);
        GraphQuery.Append('\",');
        GraphQuery.Append('namespace: \"');
        GraphQuery.Append(MetafieldSet."Namespace");
        GraphQuery.Append('\",');
        GraphQuery.Append('ownerId: \"gid://shopify/');
        GraphQuery.Append(MetafieldSet.GetOwnerTypeName());
        GraphQuery.Append('/');
        GraphQuery.Append(Format(MetafieldSet."Owner Id"));
        GraphQuery.Append('\",');
        GraphQuery.Append('value: \"');
        GraphQuery.Append(EscapeGrapQLData(MetafieldSet.Value));
        GraphQuery.Append('\",');
        GraphQuery.Append('type: \"');
        GraphQuery.Append(GetTypeName(MetafieldSet.Type));
        GraphQuery.Append('\"');
        GraphQuery.Append('},');
    end;

    local procedure EscapeGrapQLData(Data: Text): Text
    begin
        exit(Data.Replace('\', '\\\\').Replace('"', '\\\"'));
    end;

    local procedure GetTypeName(Type: Enum "Shpfy Metafield Type"): Text
    begin
        exit(Enum::"Shpfy Metafield Type".Names().Get(Enum::"Shpfy Metafield Type".Ordinals().IndexOf(Type.AsInteger())));
    end;
    #endregion

    #region From Shopify
    /// <summary>
    /// Updates the metafields in Business Central from Shopify.
    /// </summary>
    /// <remarks>
    /// Metafields with a value longer than 2048 characters will not be imported.
    /// Some metafield types are unsupported in Business Central (i.e. Rating).
    ///</remarks>
    /// <param name="JMetafields">JSON array of metafields from Shopify.</param>
    /// <param name="ParentTableNo">Table id of the parent resource.</param>
    /// <param name="OwnerId">Id of the parent resource.</param>
    internal procedure UpdateMetafieldsFromShopify(JMetafields: JsonArray; ParentTableNo: Integer; OwnerId: BigInteger)
    var
        JNode: JsonObject;
        JItem: JsonToken;
        MetafieldIds: List of [BigInteger];
        MetafieldId: BigInteger;
    begin
        CollectMetafieldIds(ParentTableNo, OwnerId, MetafieldIds);

        foreach JItem in JMetafields do begin
            JsonHelper.GetJsonObject(JItem.AsObject(), JNode, 'node');
            MetafieldId := UpdateMetadataField(ParentTableNo, OwnerId, JNode);
            MetafieldIds.Remove(MetafieldId);
        end;

        DeleteUnusedMetafields(MetafieldIds);
    end;

    /// <summary>
    /// Retrieves the metafield definitions from Shopify.
    /// </summary>
    /// <remarks>
    /// First 50 definitions will be imported
    /// Some metafield types are unsupported in Business Central (i.e. Rating).
    ///</remarks>
    /// <param name="ParentTableNo">Table id of the parent resource.</param>
    /// <param name="OwnerId">Id of the parent resource.</param>
    internal procedure GetMetafieldDefinitions(ParentTableNo: Integer; OwnerId: BigInteger)
    var
        Metafield: Record "Shpfy Metafield";
        OwnerType: Enum "Shpfy Metafield Owner Type";
        Parameters: Dictionary of [Text, Text];
        JMetafields: JsonArray;
        JMetafield: JsonToken;
        JResponse: JsonToken;
        JNode: JsonObject;
    begin
        OwnerType := Metafield.GetOwnerType(ParentTableNo);
        Parameters.Add('OwnerType', UpperCase(OwnerType.Names().Get(OwnerType.Ordinals.IndexOf(OwnerType.AsInteger()))));
        JResponse := CommunicationMgt.ExecuteGraphQL(Enum::"Shpfy GraphQL Type"::GetMetafieldDefinitions, Parameters);

        if JsonHelper.GetJsonArray(JResponse, JMetafields, 'data.metafieldDefinitions.edges') then
            foreach JMetafield in JMetafields do begin
                JsonHelper.GetJsonObject(JMetafield.AsObject(), JNode, 'node');
                CreateMetafieldDefinition(ParentTableNo, OwnerId, JNode);
            end;


    end;

    local procedure CreateMetafieldDefinition(ParentTableNo: Integer; OwnerId: BigInteger; JNode: JsonObject)
    var
        Metafield: Record "Shpfy Metafield";
        Type: Enum "Shpfy Metafield Type";
        ShpfyOTESetup: Record "Shpfy OTE Setup";
        Namespace: Text;
        Name: Text;
        TypeText: Text;
        JValidations: JsonArray;
        JValidation: JsonToken;
    // JResponse: JsonToken;
    begin
        Namespace := JsonHelper.GetValueAsText(JNode, 'namespace');
        Name := JsonHelper.GetValueAsText(JNode, 'key');
        TypeText := JsonHelper.GetValueAsText(JNode, 'type.name');

        // Some metafield types are unsupported in Business Central (i.e. Rating)
        if not ConvertToMetafieldType(TypeText, Type) then
            exit;

        Metafield.SetRange("Parent Table No.", ParentTableNo);
        Metafield.SetRange("Owner Id", OwnerId);
        Metafield.SetRange(Namespace, Namespace);
        Metafield.SetRange(Name, Name);
        Metafield.SetRange(Type, Type);
        if not Metafield.findfirst() then begin
            // exit;

            Metafield.Validate("Parent Table No.", ParentTableNo);
            Metafield."Owner Id" := OwnerId;
            Metafield.Id := JsonHelper.GetValueAsBigInteger(JNode, 'legacyResourceId');
            Metafield.Type := Type;
#pragma warning disable AA0139
            Metafield."Namespace" := Namespace;
            Metafield.Name := Name;
#pragma warning restore AA0139
            Metafield.Insert(true);
        end;
        //OTE Metafield 09.10.2025 JR START
        if ShpfyOTESetup.get() then
            if ShpfyOTESetup."Get Metafield Values" then
                if JsonHelper.GetJsonArray(JNode, JValidations, 'validations') then
                    foreach JValidation in JValidations do begin
                        // Process each validation
                        CreateOrUpdateMetafieldValues(JValidation, Metafield);
                    end;
        //OTE Metafield 09.10.2025 JR STOP 

    end;

    //OTE Metafield 09.10.2025 JR START
    local procedure CreateOrUpdateMetafieldValues(jValidation: JsonToken; _ShpfyMetafield: Record "Shpfy Metafield")
    var
        ShpfyMetafieldValue: Record "Shpfy Metafield Value";
        ShpfyCommunicationMgt: Codeunit "Shpfy Communication Mgt.";
        jObject: JsonObject;
        jArray: JsonArray;
        jValue: JsonToken;
        valuetext: text;
        ValueString: text;
        tb: TextBuilder;
    begin
        jObject := jValidation.AsObject();
        ValueString := JsonHelper.GetValueAsText(jObject, 'value');
        if ValueString.ToLower().Contains('metaobjectdefinition') then begin
            //Build Metafield definition query
            tb.AppendLine('{');
            tb.append(StrSubstNo(' "query": "query { metaobjectDefinition(id: \"%1\")', ValueString));
            tb.append('{ id name type metaobjects(first: 50) { edges { node { id handle displayName fields { key value type } } } } } }" }');
            jValidation := ShpfyCommunicationMgt.ExecuteGraphQL(tb.ToText());
            // edges := JsonHelper.GetJsonArray(jValidation, 'data.metaobjectDefinition.metaobjects.edges');
            ProcessMetaobjectDefinition(jValidation, _ShpfyMetafield);
            exit;
        end;
        // Handle regular array values (your existing logic)
        if jArray.ReadFrom(ValueString) then begin
            foreach jValue in jArray do begin
                ValueText := jValue.AsValue().AsText();
                CreateSingleMetafieldValue(_ShpfyMetafield, ValueText, '', '', '');
            end;
        end;
    end;

    local procedure ProcessMetaobjectDefinition(JResponse: JsonToken; _ShpfyMetafield: Record "Shpfy Metafield")
    var
        JEdges: JsonArray;
        JEdge: JsonToken;
        JNode: JsonObject;
        JFields: JsonArray;
        JField: JsonToken;
        NodeId: Text;
        Handle: Text;
        DisplayName: Text;
        FieldKey: Text;
        FieldValue: Text;
        FieldType: Text;
    begin
        // Get the edges array
        if JsonHelper.GetJsonArray(JResponse, JEdges, 'data.metaobjectDefinition.metaobjects.edges') then begin
            foreach JEdge in JEdges do begin
                // Get the node object
                if JsonHelper.GetJsonObject(JEdge.AsObject(), JNode, 'node') then begin
                    // Extract node properties
                    NodeId := JsonHelper.GetValueAsText(JNode, 'id');
                    Handle := JsonHelper.GetValueAsText(JNode, 'handle');
                    DisplayName := JsonHelper.GetValueAsText(JNode, 'displayName');

                    // Get fields array
                    if JsonHelper.GetJsonArray(JNode, JFields, 'fields') then begin
                        foreach JField in JFields do begin
                            // Extract field properties
                            FieldKey := JsonHelper.GetValueAsText(JField.AsObject(), 'key');
                            FieldValue := JsonHelper.GetValueAsText(JField.AsObject(), 'value');
                            FieldType := JsonHelper.GetValueAsText(JField.AsObject(), 'type');

                            // Create metafield value record with all extracted data
                            CreateSingleMetafieldValue(_ShpfyMetafield, FieldValue, NodeId, Handle, DisplayName);
                        end;
                    end else begin
                        // If no fields, create entry with just the node data
                        CreateSingleMetafieldValue(_ShpfyMetafield, DisplayName, NodeId, Handle, DisplayName);
                    end;
                end;
            end;
        end;
    end;

    local procedure CreateSingleMetafieldValue(_ShpfyMetafield: Record "Shpfy Metafield"; ValueText: Text; NodeId: Text; Handle: Text; DisplayName: Text)
    var
        ShpfyMetafieldValue: Record "Shpfy Metafield Value";
    begin
        // Check if this value already exists
        ShpfyMetafieldValue.Reset();
        ShpfyMetafieldValue.SetRange("Parent Table No.", _ShpfyMetafield."Parent Table No.");
        ShpfyMetafieldValue.SetRange(Namespace, _ShpfyMetafield.Namespace);
        ShpfyMetafieldValue.SetRange(Name, _ShpfyMetafield.Name);
        ShpfyMetafieldValue.SetRange(Type, _ShpfyMetafield.Type);
        ShpfyMetafieldValue.SetRange(Value, ValueText);

        if ShpfyMetafieldValue.IsEmpty() then begin
            // Create new metafield value record
            ShpfyMetafieldValue.Init();
            ShpfyMetafieldValue."Entry No." := 0;
            ShpfyMetafieldValue."Parent Table No." := _ShpfyMetafield."Parent Table No.";
            ShpfyMetafieldValue.Namespace := _ShpfyMetafield.Namespace;
            ShpfyMetafieldValue.Name := _ShpfyMetafield.Name;
            ShpfyMetafieldValue.Type := _ShpfyMetafield.Type;
            ShpfyMetafieldValue.Value := ValueText;

            // Store additional metaobject data if available
            if NodeId <> '' then
                ShpfyMetafieldValue."Metafield ID" := NodeId;
            if Handle <> '' then
                ShpfyMetafieldValue."Metafield Handle" := Handle;
            if DisplayName <> '' then
                ShpfyMetafieldValue."Metafield Display Name" := DisplayName;

            ShpfyMetafieldValue.Insert(true);
        end;
    end;
    //OTE Metafield 09.10.2025 JR STOP 

    local procedure UpdateMetadataField(ParentTableNo: Integer; OwnerId: BigInteger; JNode: JsonObject): BigInteger
    var
        Metafield: Record "Shpfy Metafield";
        ValueText: Text;
        Type: Enum "Shpfy Metafield Type";
    begin
        // Shopify has no limit on the length of the value, but Business Central has a limit of 2048 characters.
        // If the value is longer than 2048 characters, Metafield is not imported.
        ValueText := JsonHelper.GetValueAsText(JNode, 'value');
        if StrLen(ValueText) > MaxStrLen(Metafield.Value) then
            exit(0);

        // Some metafield types are unsupported in Business Central (i.e. Rating)
        if not ConvertToMetafieldType(JsonHelper.GetValueAsText(JNode, 'type'), Type) then
            exit(0);

        Metafield.Validate("Parent Table No.", ParentTableNo);
        Metafield."Owner Id" := OwnerId;
        Metafield.Id := JsonHelper.GetValueAsBigInteger(JNode, 'legacyResourceId');
        Metafield.Type := Type;
#pragma warning disable AA0139
        Metafield."Namespace" := JsonHelper.GetValueAsText(JNode, 'namespace');
        Metafield.Name := JsonHelper.GetValueAsText(JNode, 'key');
        Metafield.Value := ValueText;
#pragma warning restore AA0139
        if not Metafield.Modify(false) then
            Metafield.Insert(false);

        exit(Metafield.Id);
    end;

    local procedure ConvertToMetafieldType(Value: Text; var Type: Enum "Shpfy Metafield Type"): Boolean
    var
        EnumOrdinal: Integer;
    begin
        // Some metafield types are unsupported in Business Central (i.e. Rating)
        if not Enum::"Shpfy Metafield Type".Ordinals().Get(Enum::"Shpfy Metafield Type".Names().IndexOf(Value), EnumOrdinal) then
            exit(false);

        Type := Enum::"Shpfy Metafield Type".FromInteger(EnumOrdinal);
        exit(true);
    end;

    local procedure CollectMetafieldIds(ParentTableId: Integer; OwnerId: BigInteger; MetafieldIds: List of [BigInteger])
    var
        Metafield: Record "Shpfy Metafield";
    begin
        MetaField.SetRange("Parent Table No.", ParentTableId);
        Metafield.SetRange("Owner Id", OwnerId);
        if Metafield.FindSet() then
            repeat
                MetafieldIds.Add(Metafield.Id);
            until Metafield.Next() = 0;
    end;

    local procedure DeleteUnusedMetafields(MetafieldIds: List of [BigInteger])
    var
        Metafield: Record "Shpfy Metafield";
        MetafieldId: BigInteger;
    begin
        foreach MetafieldId in MetafieldIds do begin
            Metafield.Get(MetafieldId);
            Metafield.Delete(false);
        end;
    end;

    #endregion


    [IntegrationEvent(false, false)]
    local procedure OnAfterRetrieveMetafieldsFromShopify(ParentTableId: Integer; OwnerId: BigInteger; MetafieldIds: Dictionary of [BigInteger, DateTime])
    begin
    end;
}