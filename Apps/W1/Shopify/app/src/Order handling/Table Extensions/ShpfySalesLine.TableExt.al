namespace OTE.Shopify;

using Microsoft.Sales.Document;

/// <summary>
/// TableExtension Shpfy Sales Line (ID 30104) extends Record Sales Line.
/// </summary>
tableextension 88005 "Shpfy Sales Line" extends "Sales Line"
{
    fields
    {
        field(88000; "Shpfy Order Line Id"; BigInteger)
        {
            Caption = 'Shopify Order Line Id';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(88001; "Shpfy Order No."; Code[50])
        {
            Caption = 'Shopify Order No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(88002; "Shpfy Refund Id"; BigInteger)
        {
            Caption = 'Shopify Refund Id';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(88003; "Shpfy Refund Line Id"; BigInteger)
        {
            Caption = 'Shopify Refund Line Id';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(88004; "Shpfy Refund Shipping Line Id"; BigInteger)
        {
            Caption = 'Shopify Refund Shipping Line Id';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}

