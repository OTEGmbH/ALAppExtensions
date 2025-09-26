table 88062 "Shpfy OTE Item Buffer"
{
    Caption = 'Shpfy OTE Item Buffer';
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(10; "Group Code 1"; Code[50])
        {
            Caption = 'Group Code 1';
        }
        field(11; "Group Code 2"; Code[50])
        {
            Caption = 'Group Code 2';
        }
        field(12; "Group Code 3"; Code[50])
        {
            Caption = 'Group Code 3';
        }

    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }


    procedure AddEntry(_itemNo: code[20]; _groupCode1: Code[50])
    begin
        DoAddEntry(_itemNo, _groupCode1, '', '');
    end;


    procedure AddEntry(_itemNo: code[20]; _groupCode1: Code[50]; _groupCode2: Code[50])
    begin
        DoAddEntry(_itemNo, _groupCode1, _groupCode2, '');
    end;

    procedure AddEntry(_itemNo: code[20]; _groupCode1: Code[50]; _groupCode2: Code[50]; _groupCode3: Code[50])
    begin
        DoAddEntry(_itemNo, _groupCode1, _groupCode2, _groupCode3);
    end;

    local procedure DoAddEntry(_itemNo: code[20]; _groupCode1: Code[50]; _groupCode2: Code[50]; _groupCode3: Code[50])
    begin
        rec.init();
        rec."Entry No." := g_counter;
        rec."Item No." := _itemNo;
        rec."Group Code 1" := _groupCode1;
        rec."Group Code 2" := _groupCode2;
        rec."Group Code 3" := _groupCode3;
        rec.insert();
        g_counter += 1;
    end;

    var
        g_counter: integer;
}
