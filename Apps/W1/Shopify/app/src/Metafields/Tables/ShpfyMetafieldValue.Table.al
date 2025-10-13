table 88063 "Shpfy Metafield Value"
{
    Caption = 'Shpfy Metafield Value';
    DataClassification = ToBeClassified;
    LookupPageId = "Shpfy Metafield Values";
    DrillDownPageId = "Shpfy Metafield Values";

    fields
    {
        field(1; Namespace; Text[255])
        {
            Caption = 'Namespace';
            DataClassification = SystemMetadata;
        }
        field(2; Name; Text[64])
        {
            Caption = 'Key';
            DataClassification = CustomerContent;
        }
        field(3; "Entry No."; integer)
        {
            AutoIncrement = true;
        }
        field(4; "Value"; text[1000])
        {
            Caption = 'Value';
            OptimizeForTextSearch = true;
            DataClassification = CustomerContent;
        }
        field(8; Type; Enum "Shpfy Metafield Type")
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(10; "Owner Type"; Enum "Shpfy Metafield Owner Type")
        {
            Caption = 'Owner Type';
            DataClassification = SystemMetadata;

            trigger OnValidate()
            var
                IMetafieldOwnerType: Interface "Shpfy IMetafield Owner Type";
            begin
                IMetafieldOwnerType := Rec."Owner Type";
                "Parent Table No." := IMetafieldOwnerType.GetTableId();
            end;
        }
        field(101; "Parent Table No."; Integer)
        {
            Caption = 'Parent Table No.';
            DataClassification = SystemMetadata;
            Editable = false;

            trigger OnValidate()
            begin
                "Owner Type" := GetOwnerType("Parent Table No.");
            end;
        }
        field(200; "Metafield ID"; text[150])
        {
            Caption = 'Metafield ID';
            DataClassification = SystemMetadata;
        }
        field(201; "Metafield Handle"; text[250])
        {

        }
        field(202; "Metafield Display Name"; text[250])
        {
            Caption = 'Metafield Display Name';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; "Parent Table No.", Namespace, Name, "Entry No.")
        {
            Clustered = true;
        }
        key(search; "Parent Table No.", Namespace, Name, value)
        {
        }
    }

    internal procedure GetOwnerType(ParentTableNo: Integer): Enum "Shpfy Metafield Owner Type"
    begin
        case ParentTableNo of
            Database::"Shpfy Customer":
                exit("Owner Type"::Customer);
            Database::"Shpfy Product":
                exit("Owner Type"::Product);
            Database::"Shpfy Variant":
                exit("Owner Type"::ProductVariant);
            Database::"Shpfy Company":
                exit("Owner Type"::Company);
        end;
    end;


    procedure SelectValues(var _ShpfyMetafield: Record "Shpfy Metafield")
    var

        ShpfyMetafieldValue: Record "Shpfy Metafield Value";
        ShpfyMetafieldValues: Page "Shpfy Metafield Values";
        idValues: TextBuilder;
        textValues: TextBuilder;
        morethanone: boolean;
    begin
        ShpfyMetafieldValue.setrange("Parent Table No.", _ShpfyMetafield."Parent Table No.");
        ShpfyMetafieldValue.setrange(Namespace, _ShpfyMetafield.Namespace);
        ShpfyMetafieldValue.setrange(Name, _ShpfyMetafield.Name);
        if ShpfyMetafieldValue.IsEmpty() then
            exit;

        ShpfyMetafieldValues.LookupMode(true);
        ShpfyMetafieldValues.SetTableView(ShpfyMetafieldValue);
        if ShpfyMetafieldValues.RunModal() <> action::LookupOK then
            exit;
        if _ShpfyMetafield."List Metafield" then begin
            ShpfyMetafieldValues.GetSelectionFilter(ShpfyMetafieldValue);
            morethanone := ShpfyMetafieldValue.count > 1;
            if morethanone then
                idValues.Append('[');
            if ShpfyMetafieldValue.findset(false) then
                repeat
                    if idValues.Length > 2 then
                        idValues.Append(',');
                    if shpfyMetafieldValue."Metafield ID" <> '' then
                        idValues.Append('\"' + ShpfyMetafieldValue."Metafield ID" + '\"')
                    else
                        idValues.append('\"' + ShpfyMetafieldValue.Value + '\"');
                    if textValues.Length > 0 then
                        textValues.Append(',');
                    textValues.Append(ShpfyMetafieldValue.Value);
                until shpfyMetafieldValue.next() = 0;
            if morethanone then
                idValues.Append(']');
            _ShpfyMetafield.Value := idValues.ToText();
            _ShpfyMetafield."Metafield Values" := textValues.ToText();
            _ShpfyMetafield.modify(false);
        end else begin
            ShpfyMetafieldValues.GetRecord(ShpfyMetafieldValue);
            _ShpfyMetafield.Value := ShpfyMetafieldValue.Value;
            _ShpfyMetafield."Metafield Values" := ShpfyMetafieldValue.Value;
            _ShpfyMetafield.modify(false);
        end;
    end;
}
