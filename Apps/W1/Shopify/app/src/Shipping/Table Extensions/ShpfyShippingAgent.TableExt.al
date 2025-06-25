namespace Microsoft.Integration.Shopify;

using Microsoft.Foundation.Shipping;

/// <summary>
/// TableExtension Shpfy Shipping Agent (ID 30105) extends Record Shipping Agent.
/// </summary>
tableextension 88012 "Shpfy Shipping Agent" extends "Shipping Agent"
{
    fields
    {
        field(30100; "Shpfy Tracking Company"; Enum "Shpfy Tracking Companies")
        {
            Caption = 'Shopify Tracking Company';
            DataClassification = CustomerContent;
        }
    }
}