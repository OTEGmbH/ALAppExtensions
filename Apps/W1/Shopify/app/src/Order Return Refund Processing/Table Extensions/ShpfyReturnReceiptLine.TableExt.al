namespace OTE.Shopify;

using Microsoft.Sales.History;

tableextension 88007 "Shpfy Return Receipt Line" extends "Return Receipt Line"
{
    fields
    {
        field(88003; "Shpfy Refund Id"; BigInteger)
        {
            Caption = 'Shopify Refund Id';
            DataClassification = SystemMetadata;
            Editable = false;
            TableRelation = "Shpfy Refund Header"."Refund Id";
        }

        field(88004; "Shpfy Refund Line Id"; BigInteger)
        {
            Caption = 'Shopify Refund Line Id';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}