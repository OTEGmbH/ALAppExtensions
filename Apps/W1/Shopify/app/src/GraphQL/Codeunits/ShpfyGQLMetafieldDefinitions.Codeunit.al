namespace OTE.Shopify;

/// <summary>
/// Codeunit Shpfy GQL MetafieldDefinitions (ID 30380) implements Interface Shpfy IGraphQL.
/// </summary>
codeunit 88114 "Shpfy GQL MetafieldDefinitions" implements "Shpfy IGraphQL"
{
    Access = Internal;

    /// <summary>
    /// GetGraphQL.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetGraphQL(): Text
    begin
        exit('{"query":"{ metafieldDefinitions(ownerType: {{OwnerType}}, first: 100) { edges { node { id namespace key type { name }  validations {name value } } } } }"}');
    end;

    /// <summary>
    /// GetExpectedCost.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    procedure GetExpectedCost(): Integer
    begin
        exit(16);
    end;

}
