namespace Microsoft.Integration.Shopify;

codeunit 88175 "Shpfy GQL ShopLocales" implements "Shpfy IGraphQL"
{

    internal procedure GetGraphQL(): Text
    begin
        exit('{"query":"{ shopLocales { locale primary published }}"}');
    end;

    internal procedure GetExpectedCost(): Integer
    begin
        exit(3);
    end;
}