namespace app.app;

page 88072 "Shpfy OTE Setup Card"
{
    ApplicationArea = All;
    Caption = 'Shpfy OTE Setup Card';
    PageType = Card;
    SourceTable = "Shpfy OTE Setup";
    UsageCategory = tasks;

    layout
    {
        area(Content)
        {
            group(Metafields)
            {
                Caption = 'Metafields';

                field("Get Metafield Values"; Rec."Get Metafield Values")
                {
                    ToolTip = 'Specifies the value of the Get Metafield Values field.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not rec.get() then begin
            rec.init();
            rec.insert;
        end;
    end;
}
