namespace OTE.Shopify;

/// <summary>
/// Enum Shpfy Variant Create Strategy (ID 30165).
/// </summary>
enum 88063 "Shpfy Variant Create Strategy"
{
    Access = Internal;
    Caption = 'Shopify Variant Create Strategy';
    Extensible = false;

    value(0; DEFAULT)
    {
        Caption = 'DEFAULT', Locked = true;
    }

    value(1; REMOVE_STANDALONE_VARIANT)
    {
        Caption = 'REMOVE_STANDALONE_VARIANT', Locked = true;
    }
}