namespace OTE.Shopify;

using Microsoft.Inventory.Item;

codeunit 88197 "Shpfy Disabled Value" implements "Shpfy Stock Calculation"
{
    procedure GetStock(var Item: Record Item): decimal;
    begin
        exit(0);
    end;
}

