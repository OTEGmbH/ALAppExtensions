namespace OTE.Shopify;

/// <summary>
/// Enum Shpfy Payout Status (ID 30128).
/// </summary>
enum 88058 "Shpfy Payout Status"
{
    Caption = 'Payout Status';
    Extensible = false;

    value(0; Unknown)
    {
        Caption = ' ';
    }
    value(1; Scheduled)
    {
        Caption = 'Scheduled';
    }
    value(2; "In Transit")
    {
        Caption = 'In Transit';
    }
    value(3; Paid)
    {
        Caption = 'Paid';
    }
    value(4; Failed)
    {
        Caption = 'Failed';
    }
    value(5; Canceled)
    {
        Caption = 'Canceled';
    }

}
