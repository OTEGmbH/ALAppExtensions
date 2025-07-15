namespace OTE.Shopify;

codeunit 88195 "Shpfy Can Have Stock" implements "Shpfy IStock Available"
{
    procedure CanHaveStock(): Boolean
    begin
        exit(true);
    end;
}