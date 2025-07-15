namespace OTE.Shopify;

enum 88001 "Shpfy Logging Mode"
{
    Extensible = false;

    value(0; "Error Only")
    {
        Caption = 'Error Only';
    }
    value(1; All)
    {
        Caption = 'All';
    }
    value(2; Disabled)
    {
        Caption = 'Disabled';
    }
}