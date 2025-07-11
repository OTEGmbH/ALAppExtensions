namespace app.app;

using Microsoft.Sales.History;

tableextension 88015 "Shpfy Sales Cr Memo Line Ext." extends "Sales Cr.Memo Line"
{
    fields
    {
        field(30100; "Shpfy Order Line Id"; BigInteger)
        {
            Caption = 'Shopify Order Line Id';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(30101; "Shpfy Order No."; Code[50])
        {
            Caption = 'Shopify Order No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}
