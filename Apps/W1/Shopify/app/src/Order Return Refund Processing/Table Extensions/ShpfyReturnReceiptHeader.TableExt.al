namespace OTE.Shopify;

using Microsoft.Sales.History;

tableextension 88006 "Shpfy Return Receipt Header" extends "Return Receipt Header"
{
    fields
    {
        field(88000; "Shpfy Refund Id"; BigInteger)
        {
            Caption = 'Shopify Refund Id';
            DataClassification = SystemMetadata;
            Editable = false;
            TableRelation = "Shpfy Refund Header"."Refund Id";
        }
    }
}