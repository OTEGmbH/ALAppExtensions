namespace OTE.Shopify;

using Microsoft.Sales.History;

/// <summary>
/// TableExtension "Shpfy Sales Shipment Line (ID 30107) extends Record Sales Shipment Line.
/// </summary>
tableextension 88011 "Shpfy Sales Shipment Line" extends "Sales Shipment Line"
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
    }
}

