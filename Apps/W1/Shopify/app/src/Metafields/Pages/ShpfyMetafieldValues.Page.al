namespace app.app;

page 88071 "Shpfy Metafield Values"
{
    ApplicationArea = All;
    Caption = 'Shpfy Metafield Values';
    PageType = List;
    SourceTable = "Shpfy Metafield Value";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Namespace; Rec.Namespace)
                {
                    ToolTip = 'Specifies the value of the Namespace field.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Key field.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Value"; Rec."Value")
                {
                    ToolTip = 'Specifies the value of the Value field.';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("Owner Type"; Rec."Owner Type")
                {
                    ToolTip = 'Specifies the value of the Owner Type field.';
                }
                field("Parent Table No."; Rec."Parent Table No.")
                {
                    ToolTip = 'Specifies the value of the Parent Table No. field.';
                }
                field("Metafield ID"; Rec."Metafield ID")
                {
                    ToolTip = 'Specifies the value of the Metafield ID field.';
                }
                field("Metafield Handle"; Rec."Metafield Handle")
                {
                    ToolTip = 'Specifies the value of the Metafield Handle field.';
                }
                field("Metafield Display Name"; Rec."Metafield Display Name")
                {
                    ToolTip = 'Specifies the value of the Metafield Display Name field.';
                }
            }
        }
    }
}
