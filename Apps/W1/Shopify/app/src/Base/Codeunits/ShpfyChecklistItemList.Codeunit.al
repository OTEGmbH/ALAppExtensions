namespace OTE.Shopify;

using Microsoft.Inventory.Item;

codeunit 88002 "Shpfy Checklist Item List"
{
    trigger OnRun()
    begin
        Page.Run(Page::"Item List");
    end;
}