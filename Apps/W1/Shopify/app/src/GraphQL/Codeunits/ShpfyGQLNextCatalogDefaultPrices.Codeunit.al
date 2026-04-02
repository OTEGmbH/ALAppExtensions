namespace OTE.Shopify;

codeunit 88301 "Shpfy GQL NextCatalogDefPrc" implements "Shpfy IGraphQL"
{
    Access = Internal;

    /// <summary>
    /// GetGraphQL.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    internal procedure GetGraphQL(): Text
    begin
        exit('{"query": "query { catalog(id: \"gid://shopify/Catalog/{{CatalogId}}\") { id publication { products(first:100, after:\"{{After}}\") { edges { cursor node { id variants(first:100) { edges { node { id price compareAtPrice } } } } } pageInfo { hasNextPage } } } } }"}');
    end;

    /// <summary>
    /// GetExpectedCost.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    internal procedure GetExpectedCost(): Integer
    begin
        exit(404);
    end;
}
