namespace OTE.Shopify;

codeunit 88302 "Shpfy GQL InventoryByItem" implements "Shpfy IGraphQL"
{
    Access = Internal;

    internal procedure GetGraphQL(): Text
    begin
        exit('{"query":"{product(id:\"gid://shopify/Product/{{ProductId}}\"){variants(first:100){edges{node{id inventoryItem{id inventoryLevel(locationId:\"gid://shopify/Location/{{LocationId}}\"){quantities(names:\"available\"){quantity}}}}}}}}"}');
    end;

    internal procedure GetExpectedCost(): Integer
    begin
        exit(5);
    end;

}
