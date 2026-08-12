namespace OTE.Shopify;

using OTE.Shopify;

/// <summary>
/// Codeunit Shpfy Sync Inventory (ID 30197).
/// </summary>
codeunit 88201 "Shpfy Sync Inventory"
{
    Access = Internal;
    TableNo = "Shpfy Shop Inventory";

    var
        InventoryApi: Codeunit "Shpfy Inventory API";

    trigger OnRun()
    var
        ShopInventory: Record "Shpfy Shop Inventory";
        ShopLocation: Record "Shpfy Shop Location";
        ShopFilter: Text;
    begin
        ShopFilter := Rec.GetFilter("Shop Code");
        if ShopFilter <> '' then begin
            ShopLocation.SetRange("Shop Code", ShopFilter);
            ShopInventory.SetRange("Shop Code", ShopFilter);
        end;

        ShopLocation.SetFilter("Stock Calculation", '<>%1', ShopLocation."Stock Calculation"::Disabled);
        if ShopLocation.FindSet(false) then begin
            InventoryApi.SetShop(ShopLocation."Shop Code");
            InventoryApi.SetInventoryIds();
            repeat
                InventoryApi.ImportStock(ShopLocation);
            until ShopLocation.Next() = 0;
        end;
        InventoryApi.RemoveUnusedInventoryIds();
        InventoryApi.ExportStock(ShopInventory);
    end;

    procedure ImportStock(_shopCode: code[20])
    var
        ShopLocation: Record "Shpfy Shop Location";
    begin
        ShopLocation.SetRange("Shop Code", _shopCode);
        ShopLocation.SetFilter("Stock Calculation", '<>%1', ShopLocation."Stock Calculation"::Disabled);
        if ShopLocation.FindSet(false) then begin
            InventoryApi.SetShop(ShopLocation."Shop Code");
            InventoryApi.SetInventoryIds();
            repeat
                InventoryApi.ImportStock(ShopLocation);
            until ShopLocation.Next() = 0;
        end;
        InventoryApi.RemoveUnusedInventoryIds();
    end;

    procedure ImportStock(_shopCode: code[20]; var _shpfyProducts: record "Shpfy Product")
    var
        ShopLocation: Record "Shpfy Shop Location";
    begin
        ShopLocation.SetRange("Shop Code", _shopCode);
        ShopLocation.SetFilter("Stock Calculation", '<>%1', ShopLocation."Stock Calculation"::Disabled);
        if ShopLocation.FindSet(false) then begin
            InventoryApi.SetShop(ShopLocation."Shop Code");
            InventoryApi.SetInventoryIds();
            repeat
                InventoryApi.ImportStock(ShopLocation, _shpfyProducts);
            until ShopLocation.Next() = 0;
        end;
        InventoryApi.RemoveUnusedInventoryIds();
    end;

    procedure ExportStock(var _ShopInventory: Record "Shpfy Shop Inventory")
    var
        ShpfyShopInventory: Record "Shpfy Shop Inventory";
        MarkedShpfyShopInventory: Record "Shpfy Shop Inventory";
    begin
        if _ShopInventory.findset(false) then
            repeat
                ShpfyShopInventory.setrange("Shop Code", _ShopInventory."Shop Code");
                ShpfyShopInventory.setrange("Product Id", _ShopInventory."Product Id");
                ShpfyShopInventory.setrange("Variant Id", _ShopInventory."Variant Id");
                ShpfyShopInventory.setrange("Location Id", _ShopInventory."Location Id");
                if ShpfyShopInventory.findfirst() then begin
                    MarkedShpfyShopInventory.GetBySystemId(ShpfyShopInventory.SystemId);
                    MarkedShpfyShopInventory.mark(true);
                end;
            until _ShopInventory.Next() = 0;
        MarkedShpfyShopInventory.MarkedOnly(true);
        InventoryApi.ExportStock(MarkedShpfyShopInventory);
    end;
}