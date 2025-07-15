namespace OTE.Shopify;

codeunit 88196 "Shpfy Can Not Have Stock" implements "Shpfy IStock Available"
{
    procedure CanHaveStock(): Boolean
    begin
        exit(false);
    end;
}