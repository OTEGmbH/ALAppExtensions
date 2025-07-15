namespace OTE.Shopify;

using Microsoft.Finance.GeneralLedger.Journal;

tableextension 88014 "Shpfy Gen. Journal Line" extends "Gen. Journal Line"
{
    fields
    {
        field(88000; "Shpfy Transaction Id"; BigInteger)
        {
            Caption = 'Shopify Transaction Id';
            DataClassification = SystemMetadata;
            Editable = false;
        }
    }
}