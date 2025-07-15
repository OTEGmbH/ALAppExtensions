namespace OTE.Shopify;

using Microsoft.Sales.Receivables;

tableextension 88013 "Shpfy Cust. Ledger Entry" extends "Cust. Ledger Entry"
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