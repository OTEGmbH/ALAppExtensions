namespace OTE.Shopify;

using OTE.Shopify;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Item.Catalog;

/// <summary>
/// Codeunit Shpfy Create Product (ID 30174).
/// </summary>
codeunit 88268 "Shpfy Create Product"
{
    Access = Internal;
    Permissions =
        tabledata Item = r,
        tabledata "Item Reference" = r,
        tabledata "Item Unit of Measure" = r,
        tabledata "Item Variant" = r;
    TableNo = Item;

    var
        Shop: Record "Shpfy Shop";
        ProductApi: Codeunit "Shpfy Product API";
        ProductExport: Codeunit "Shpfy Product Export";
        ProductPriceCalc: Codeunit "Shpfy Product Price Calc.";
        VariantApi: Codeunit "Shpfy Variant API";
        Events: Codeunit "Shpfy Product Events";
        Getlocations: Boolean;
        ProductId: BigInteger;
        ItemVariantIsBlockedLbl: Label 'Item variant is blocked or sales blocked.';
        G_ShpfyOTEItemBuffer: Record "Shpfy OTE Item Buffer";
        GroupByBufferTable: boolean;

    trigger OnRun()
    var
        ShopifyProduct: Record "Shpfy Product";
    begin
        if Getlocations then begin
            Codeunit.Run(Codeunit::"Shpfy Sync Shop Locations", Shop);
            Commit();
            Getlocations := false;
        end;

        //OTE JR 26.09.2025 JR START
        if GroupByBufferTable then begin
            ShopifyProduct.SetRange("Shop Code", Shop.Code);
            ShopifyProduct.SetRange("Item SystemId", Rec.SystemId);
            ShopifyProduct.SetRange("Group Code 1", G_ShpfyOTEItemBuffer."Group Code 1");
            ShopifyProduct.SetRange("Group Code 2", G_ShpfyOTEItemBuffer."Group Code 2");
            ShopifyProduct.SetRange("Group Code 3", G_ShpfyOTEItemBuffer."Group Code 3");
            if ShopifyProduct.IsEmpty then
                CreateProduct(Rec);
        end else begin
            ShopifyProduct.SetRange("Shop Code", Shop.Code);
            ShopifyProduct.SetRange("Item SystemId", Rec.SystemId);
            if ShopifyProduct.IsEmpty then
                CreateProduct(Rec);
        end;
        // ShopifyProduct.SetRange("Shop Code", Shop.Code);
        //     ShopifyProduct.SetRange("Item SystemId", Rec.SystemId);
        //     if ShopifyProduct.IsEmpty then
        //         CreateProduct(Rec); 
        //OTE JR 26.09.2025 JR STOP 
    end;

    /// <summary> 
    /// Create Product.
    /// </summary>
    /// <param name="Item">Parameter of type Record Item.</param>
    local procedure CreateProduct(Item: Record Item)
    var
        TempShopifyProduct: Record "Shpfy Product" temporary;
        TempShopifyVariant: Record "Shpfy Variant" temporary;
        TempShopifyTag: Record "Shpfy Tag" temporary;
        ShpfyProductExport: Codeunit "Shpfy Product Export";
    begin
        CreateTempProduct(Item, TempShopifyProduct, TempShopifyVariant, TempShopifyTag);
        if not VariantApi.FindShopifyProductVariant(TempShopifyProduct, TempShopifyVariant) then
            ProductId := ProductApi.CreateProduct(TempShopifyProduct, TempShopifyVariant, TempShopifyTag)
        else
            ProductId := TempShopifyProduct.Id;

        //OTE Metafields 10.07.2025 JR START
        OnAfterCreateProduct(ProductId, Shop);
        if Shop."Product Metafields To Shopify" then
            ShpfyProductExport.UpdateMetafields(ProductId);
        //OTE Metafields 10.07.2025 JR STOP 

        if ProductId <> 0 then
            ProductExport.UpdateProductTranslations(ProductId, Item);
    end;

    internal procedure CreateTempProduct(Item: Record Item; var TempShopifyProduct: Record "Shpfy Product" temporary; var TempShopifyVariant: Record "Shpfy Variant" temporary; var TempShopifyTag: Record "Shpfy Tag" temporary)
    var
        ItemUnitofMeasure: Record "Item Unit of Measure";
        ItemVariant: Record "Item Variant";
        SkippedRecord: Codeunit "Shpfy Skipped Record";
        Skip: boolean;
        Id: Integer;
        ICreateProductStatus: Interface "Shpfy ICreateProductStatusValue";
    begin
        Clear(TempShopifyProduct);
        TempShopifyProduct."Shop Code" := Shop.Code;
        TempShopifyProduct."Item SystemId" := Item.SystemId;
        //OTE Grouping 26.09.2025 JR START
        TempShopifyProduct."Group Code 1" := G_ShpfyOTEItemBuffer."Group Code 1";
        TempShopifyProduct."Group Code 2" := G_ShpfyOTEItemBuffer."Group Code 2";
        TempShopifyProduct."Group Code 3" := G_ShpfyOTEItemBuffer."Group Code 3";
        TempShopifyProduct."Group Description 1" := G_ShpfyOTEItemBuffer."Group Description 1";
        TempShopifyProduct."Group Description 2" := G_ShpfyOTEItemBuffer."Group Description 2";
        TempShopifyProduct."Group Description 3" := G_ShpfyOTEItemBuffer."Group Description 3";
        //OTE Grouping 26.09.2025 JR STOP 
        ProductExport.FillInProductFields(Item, TempShopifyProduct);
        ICreateProductStatus := Shop."Status for Created Products";
        TempShopifyProduct.Status := ICreateProductStatus.GetStatus(Item);
        ItemVariant.SetRange("Item No.", Item."No.");
        //OTE Grouping 26.09.2025 JR START
        OnBeforeLoopItemVariant(ItemVariant, TempShopifyProduct, Shop);
        //OTE Grouping 26.09.2025 JR STOP 
        if ItemVariant.FindSet(false) then
            repeat
                //OTE Skip other variants 08.07.2025 JR START
                skip := false;
                OnBeforeProcessItemVariant(ItemVariant, TempShopifyProduct, Shop, Skip);
                //OTE Skip other variants 08.07.2025 JR STOP 
                if Skip then
                    continue;
                if ItemVariant.Blocked or ItemVariant."Sales Blocked" then
                    SkippedRecord.LogSkippedRecord(ItemVariant.RecordId, ItemVariantIsBlockedLbl, Shop)
                else begin
                    TempShopifyProduct."Has Variants" := true;
                    if Shop."UoM as Variant" then begin
                        ItemUnitofMeasure.SetRange("Item No.", Item."No.");
                        if ItemUnitofMeasure.FindSet(false) then
                            repeat
                                Id += 1;
                                Clear(TempShopifyVariant);
                                TempShopifyVariant.Id := Id;
                                TempShopifyVariant."Available For Sales" := true;
                                TempShopifyVariant.Barcode := CopyStr(GetBarcode(Item."No.", ItemVariant.Code, ItemUnitofMeasure.Code), 1, MaxStrLen(TempShopifyVariant.Barcode));
                                ProductPriceCalc.CalcPrice(Item, ItemVariant.Code, ItemUnitofMeasure.Code, TempShopifyVariant."Unit Cost", TempShopifyVariant.Price, TempShopifyVariant."Compare at Price");
                                TempShopifyVariant.Title := ItemVariant.Description;
                                TempShopifyVariant."Inventory Policy" := Shop."Default Inventory Policy";
                                TempShopifyVariant.SKU := GetVariantSKU(TempShopifyVariant.Barcode, Item."No.", ItemVariant.Code, Item."Vendor Item No.");
                                TempShopifyVariant."Tax Code" := Item."Tax Group Code";
                                TempShopifyVariant.Taxable := true;
                                TempShopifyVariant.Weight := Item."Gross Weight";
                                TempShopifyVariant."Option 1 Name" := 'Variant';
                                TempShopifyVariant."Option 1 Value" := ItemVariant.Code;
                                TempShopifyVariant."Option 2 Name" := Shop."Option Name for UoM";
                                TempShopifyVariant."Option 2 Value" := ItemUnitofMeasure.Code;
                                TempShopifyVariant."Shop Code" := Shop.Code;
                                TempShopifyVariant."Item SystemId" := Item.SystemId;
                                TempShopifyVariant."Item Variant SystemId" := ItemVariant.SystemId;
                                TempShopifyVariant."UoM Option Id" := 2;
                                TempShopifyVariant.Insert(false);

                                //OTE Variant Options overwrite 09.07.2025 JR START
                                OnAfterInsertShopifyVariant(TempShopifyVariant, ItemVariant, TempShopifyProduct, Shop);
                            //OTE Variant Options overwrite 09.07.2025 JR STOP 

                            until ItemUnitofMeasure.Next() = 0;
                    end else begin
                        Id += 1;
                        Clear(TempShopifyVariant);
                        TempShopifyVariant.Id := Id;
                        TempShopifyVariant."Available For Sales" := true;
                        TempShopifyVariant.Barcode := CopyStr(GetBarcode(Item."No.", ItemVariant.Code, Item."Sales Unit of Measure"), 1, MaxStrLen(TempShopifyVariant.Barcode));
                        ProductPriceCalc.CalcPrice(Item, ItemVariant.Code, Item."Sales Unit of Measure", TempShopifyVariant."Unit Cost", TempShopifyVariant.Price, TempShopifyVariant."Compare at Price");
                        TempShopifyVariant.Title := ItemVariant.Description;
                        TempShopifyVariant."Inventory Policy" := Shop."Default Inventory Policy";
                        TempShopifyVariant.SKU := GetVariantSKU(TempShopifyVariant.Barcode, Item."No.", ItemVariant.Code, GetVendorItemNo(Item."No.", ItemVariant.Code, Item."Sales Unit of Measure"));
                        TempShopifyVariant."Tax Code" := Item."Tax Group Code";
                        TempShopifyVariant.Taxable := true;
                        TempShopifyVariant.Weight := Item."Gross Weight";
                        TempShopifyVariant."Option 1 Name" := 'Variant';
                        TempShopifyVariant."Option 1 Value" := ItemVariant.Code;
                        TempShopifyVariant."Shop Code" := Shop.Code;
                        TempShopifyVariant."Item SystemId" := Item.SystemId;
                        TempShopifyVariant."Item Variant SystemId" := ItemVariant.SystemId;
                        TempShopifyVariant.Insert(false);
                        //OTE Variant Options overwrite 09.07.2025 JR START
                        OnAfterInsertShopifyVariant(TempShopifyVariant, ItemVariant, TempShopifyProduct, Shop);
                        //OTE Variant Options overwrite 09.07.2025 JR STOP 
                    end;
                end;
            until ItemVariant.Next() = 0
        else
            if Shop."UoM as Variant" then begin
                ItemUnitofMeasure.SetRange("Item No.", Item."No.");
                if ItemUnitofMeasure.FindSet(false) then
                    repeat
                        TempShopifyProduct."Has Variants" := true;
                        Id += 1;
                        Clear(TempShopifyVariant);
                        TempShopifyVariant.Id := Id;
                        TempShopifyVariant."Available For Sales" := true;
                        TempShopifyVariant.Barcode := CopyStr(GetBarcode(Item."No.", '', ItemUnitofMeasure.Code), 1, MaxStrLen(TempShopifyVariant.Barcode));
                        ProductPriceCalc.CalcPrice(Item, '', ItemUnitofMeasure.Code, TempShopifyVariant."Unit Cost", TempShopifyVariant.Price, TempShopifyVariant."Compare at Price");
                        TempShopifyVariant.Title := Item.Description;
                        TempShopifyVariant."Inventory Policy" := Shop."Default Inventory Policy";
                        TempShopifyVariant.SKU := GetVariantSKU(TempShopifyVariant.Barcode, Item."No.", '', Item."Vendor Item No.");
                        TempShopifyVariant."Tax Code" := Item."Tax Group Code";
                        TempShopifyVariant.Taxable := true;
                        TempShopifyVariant.Weight := Item."Gross Weight";
                        TempShopifyVariant."Option 1 Name" := Shop."Option Name for UoM";
                        TempShopifyVariant."Option 1 Value" := ItemUnitofMeasure.Code;
                        TempShopifyVariant."Shop Code" := Shop.Code;
                        TempShopifyVariant."Item SystemId" := Item.SystemId;
                        TempShopifyVariant."UoM Option Id" := 1;
                        TempShopifyVariant.Insert(false);
                        //OTE Variant Options overwrite 09.07.2025 JR START
                        OnAfterInsertShopifyVariant(TempShopifyVariant, ItemVariant, TempShopifyProduct, Shop);
                    //OTE Variant Options overwrite 09.07.2025 JR STOP 
                    until ItemUnitofMeasure.Next() = 0;
            end else
                CreateTempShopifyVariantFromItem(Item, TempShopifyVariant);

        TempShopifyProduct.Insert(false);
        Events.OnAfterCreateTempShopifyProduct(Item, TempShopifyProduct, TempShopifyVariant, TempShopifyTag);
    end;

    /// <summary> 
    /// Get Barcode.
    /// </summary>
    /// <param name="ItemNo">Parameter of type Code[20].</param>
    /// <param name="VariantCode">Parameter of type Code[10].</param>
    /// <param name="UoM">Parameter of type Code[10].</param>
    /// <returns>Return value of type Text.</returns>
    local procedure GetBarcode(ItemNo: Code[20]; VariantCode: Code[10]; UoM: Code[10]): Text;
    var
        ItemReferenceMgt: Codeunit "Shpfy Item Reference Mgt.";
    begin
        exit(ItemReferenceMgt.GetItemBarcode(ItemNo, VariantCode, UoM));
    end;

    /// <summary> 
    /// Get Vendor Item No.
    /// </summary>
    /// <param name="ItemNo">Parameter of type Code[20].</param>
    /// <param name="VariantCode">Parameter of type Code[10].</param>
    /// <param name="UoM">Parameter of type Code[10].</param>
    /// <returns>Return value of type Code[50].</returns>
    local procedure GetVendorItemNo(ItemNo: Code[20]; VariantCode: Code[10]; UoM: Code[10]): Code[50];
    var
        Item: Record Item;
        ItemReferenceMgt: Codeunit "Shpfy Item Reference Mgt.";
    begin
        if Item.Get(ItemNo) then
            exit(ItemReferenceMgt.GetItemReference(ItemNo, VariantCode, UoM, "Item Reference Type"::Vendor, Item."Vendor No."));
    end;

    local procedure GetVariantSKU(BarCode: Text[50]; ItemNo: Text[20]; VariantCode: Text[10]; VendorItemNo: Text[50]): Text[50]
    begin
        case Shop."SKU Mapping" of
            Shop."SKU Mapping"::"Bar Code":
                exit(BarCode);
            Shop."SKU Mapping"::"Item No.":
                exit(ItemNo);
            Shop."SKU Mapping"::"Variant Code":
                if VariantCode <> '' then
                    exit(VariantCode);
            Shop."SKU Mapping"::"Item No. + Variant Code":
                if VariantCode <> '' then
                    exit(ItemNo + Shop."SKU Field Separator" + VariantCode)
                else
                    exit(ItemNo);
            Shop."SKU Mapping"::"Vendor Item No.":
                exit(VendorItemNo);
        end;
    end;

    /// <summary>
    /// Creates a temporary Shopify variant with information from an item.
    /// </summary>
    /// <param name="Item">The item to create the variant from.</param>
    /// <param name="TempShopifyVariant">The temporary Shopify variant record set where the variant will be inserted.</param>
    internal procedure CreateTempShopifyVariantFromItem(Item: Record Item; var TempShopifyVariant: Record "Shpfy Variant" temporary)
    begin
        Clear(TempShopifyVariant);
        TempShopifyVariant."Available For Sales" := true;
        TempShopifyVariant.Barcode := CopyStr(GetBarcode(Item."No.", '', Item."Sales Unit of Measure"), 1, MaxStrLen(TempShopifyVariant.Barcode));
        ProductPriceCalc.CalcPrice(Item, '', Item."Sales Unit of Measure", TempShopifyVariant."Unit Cost", TempShopifyVariant.Price, TempShopifyVariant."Compare at Price");
        TempShopifyVariant.Title := ''; // Title will be assigned to "Default Title" in Shopify as no Options are set.
        TempShopifyVariant."Inventory Policy" := Shop."Default Inventory Policy";
        TempShopifyVariant.SKU := GetVariantSKU(TempShopifyVariant.Barcode, Item."No.", '', Item."Vendor Item No.");
        TempShopifyVariant."Tax Code" := Item."Tax Group Code";
        TempShopifyVariant.Taxable := true;
        TempShopifyVariant.Weight := Item."Gross Weight";
        TempShopifyVariant."Shop Code" := Shop.Code;
        TempShopifyVariant."Item SystemId" := Item.SystemId;
        TempShopifyVariant.Insert(false);
    end;

    /// <summary> 
    /// Set Shop.
    /// </summary>
    /// <param name="Code">Parameter of type Code[20].</param>
    internal procedure SetShop(Code: Code[20])
    begin
        if (Code <> '') and (Shop.Code <> Code) then begin
            Clear(Shop);
            Shop.Get(Code);
            ProductApi.SetShop(Shop);
            VariantApi.SetShop(Shop);
            ProductPriceCalc.SetShop(Shop);
            ProductExport.SetShop(Shop);
            Getlocations := true;
        end;
    end;

    /// <summary> 
    /// Set Shop.
    /// </summary>
    /// <param name="ShopifyShop">Parameter of type Record "Shopify Shop".</param>
    internal procedure SetShop(ShopifyShop: Record "Shpfy Shop")
    begin
        SetShop(ShopifyShop.Code);
    end;

    internal procedure GetProductId(): BigInteger
    begin
        exit(ProductId);
    end;

    internal procedure ChangeDefaultProductLocation(ErrorInfo: ErrorInfo)
    var
        ShpfyShop: Record "Shpfy Shop";
        ShopLocation: Record "Shpfy Shop Location";
    begin
        if ShpfyShop.Get(ErrorInfo.RecordId) then begin
            ShopLocation.SetRange("Shop Code", ShpfyShop.Code);
            Page.Run(Page::"Shpfy Shop Locations Mapping", ShopLocation);
        end;
    end;

    /*

      #######  ######## ######## 
     ##     ##    ##    ##       
     ##     ##    ##    ##       
     ##     ##    ##    ######   
     ##     ##    ##    ##       
     ##     ##    ##    ##       
      #######     ##    ######## 

    */
    //OTE BC 08.07.2025 JR START
    [BusinessEvent(false)]
    local procedure OnBeforeProcessItemVariant(var ItemVariant: Record "Item Variant"; var TempShopifyProduct: Record "Shpfy Product" temporary; Shop: Record "Shpfy Shop"; var Skip: boolean)
    begin
    end;

    [BusinessEvent(false)]
    local procedure OnBeforeLoopItemVariant(var ItemVariant: Record "Item Variant"; var TempShopifyProduct: Record "Shpfy Product" temporary; Shop: Record "Shpfy Shop")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertShopifyVariant(var TempShopifyVariant: Record "Shpfy Variant" temporary; ItemVariant: Record "Item Variant"; var TempShopifyProduct: Record "Shpfy Product" temporary; Shop: Record "Shpfy Shop")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateProduct(ProductId: BigInteger; Shop: Record "Shpfy Shop")
    begin
    end;
    //OTE BC 08.07.2025 JR STOP 

    //This method is needed to group shopify items not only by the item number / item systemid
    procedure SetItemBufferEntry(var _ShpfyOTEItemBuffer: Record "Shpfy OTE Item Buffer")
    begin
        G_ShpfyOTEItemBuffer := _ShpfyOTEItemBuffer;
        GroupByBufferTable := true;
    end;
}