namespace OTE.Shopify;

using Microsoft.Sales.Document;

/// <summary>
/// TableExtension Shpfy Sales Header (ID 30101) extends Record Sales Header.
/// </summary>
tableextension 88002 "Shpfy Sales Header" extends "Sales Header"
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

#if not CLEANSCHEMA28
        field(88002; "Shpfy Risk Level"; Enum "Shpfy Risk Level")
        {
            Caption = 'Risk Level';
            FieldClass = FlowField;
            CalcFormula = lookup("Shpfy Order Header"."Risk Level" where("Shopify Order Id" = field("Shpfy Order Id")));
            ObsoleteReason = 'This field is not imported.';
#if not CLEAN25
            ObsoleteState = Pending;
            ObsoleteTag = '25.0';
#else
                            ObsoleteState = Removed;
                            ObsoleteTag = '28.0';
#endif
        }
#endif
        field(88003; "Shpfy Refund Id"; BigInteger)
        {
            Caption = 'Shopify Refund Id';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}

