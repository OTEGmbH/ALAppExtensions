namespace OTE.Shopify;

using Microsoft.Sales.History;

/// <summary>
/// TableExtensionShpfy Sales Shipment Header (ID 30106) extends Record Sales Shipment Header.
/// </summary>
tableextension 88010 "Shpfy Sales Shipment Header" extends "Sales Shipment Header"
{
    fields
    {
        field(88000; "Shpfy Order Id"; BigInteger)
        {
            Caption = 'Shopify Order Id';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(88001; "Shpfy Order No."; Code[50])
        {
            Caption = 'Shopify Order No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(88002; "Shpfy Fulfillment Id"; BigInteger)
        {
            Caption = 'Shopify Fulfillment Id';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}

