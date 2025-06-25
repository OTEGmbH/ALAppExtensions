namespace Microsoft.Integration.Shopify;

using Microsoft.Finance.GeneralLedger.Journal;

tableextension 88014 "Shpfy Gen. Journal Line" extends "Gen. Journal Line"
{
    fields
    {
        field(30100; "Shpfy Transaction Id"; BigInteger)
        {
            Caption = 'Shopify Transaction Id';
            DataClassification = SystemMetadata;
            Editable = false;
        }
    }
}