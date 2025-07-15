namespace OTE.Shopify;

/// <summary>
/// Report Shpfy Sync Stock to Shopify (ID 30102).
/// </summary>
report 88009 "Shpfy Sync Stock to Shopify"
{
    ApplicationArea = All;
    Caption = 'Sync Stock To Shopify';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Shop; "Shpfy Shop")
        {
            RequestFilterFields = Code;

            trigger OnAfterGetRecord()
            var
                ShopifyShopInventory: Record "Shpfy Shop Inventory";
            begin
                ShopifyShopInventory.Reset();
                ShopifyShopInventory.SetRange("Shop Code", Shop.Code);
                //OTE SHOPIFY 26.06.2025 JR START
                if g_ShopifyShopInventory.GetFilters <> '' then
                    ShopifyShopInventory.copy(g_ShopifyShopInventory);
                //OTE SHOPIFY 26.06.2025 JR STOP 
                CodeUnit.Run(Codeunit::"Shpfy Sync Inventory", ShopifyShopInventory);
            end;
        }
    }

    //OTE
    procedure SetShopifyShopInventoryFilters(var _ShopifyShopInventory: Record "Shpfy Shop Inventory")
    begin
        g_ShopifyShopInventory.Copy(_ShopifyShopInventory);
    end;

    var
        g_ShopifyShopInventory: Record "Shpfy Shop Inventory";

}