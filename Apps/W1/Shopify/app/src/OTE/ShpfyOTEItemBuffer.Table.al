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

        field(20; "Group Description 1"; text[100])
        {
            Caption = 'Group Description 1';
        }
        field(21; "Group Description 2"; text[100])
        {
            Caption = 'Group Description 2';
        }
        field(22; "Group Description 3"; text[100])
        {
            Caption = 'Group Description 3';
        }

    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Search; "Item No.", "Group Code 1", "Group Code 2", "Group Code 3")
        {
        }
    }


    procedure AddEntry(_itemNo: code[20]; _groupCode1: Code[50]; _groupDesc1: text[100])
    begin
        DoAddEntry(_itemNo, _groupCode1, _groupDesc1, '', '', '', '');
    end;


    procedure AddEntry(_itemNo: code[20]; _groupCode1: Code[50]; _groupDesc1: text[100]; _groupCode2: Code[50]; _groupDesc2: text[100])
    begin
        DoAddEntry(_itemNo, _groupCode1, _groupDesc1, _groupCode2, _groupDesc2, '', '');
    end;

    procedure AddEntry(_itemNo: code[20]; _groupCode1: Code[50]; _groupDesc1: text[100]; _groupCode2: Code[50]; _groupDesc2: text[100]; _groupCode3: Code[50]; _groupDesc3: text[100])
    begin
        DoAddEntry(_itemNo, _groupCode1, _groupDesc1, _groupCode2, _groupDesc2, _groupCode3, _groupDesc3);
    end;

    local procedure DoAddEntry(_itemNo: code[20]; _groupCode1: Code[50]; _groupDesc1: text[100]; _groupCode2: Code[50]; _groupText2: text[100]; _groupCode3: Code[50]; _groupText3: text[100])
    begin
        rec.reset();
        rec.setrange("Item No.", _itemNo);
        rec.setrange("Group Code 1", _groupCode1);
        rec.setrange("Group Code 2", _groupCode2);
        rec.setrange("Group Code 3", _groupCode3);
        if not rec.IsEmpty then
            exit; // already exists
        rec.reset();
        rec.init();
        rec."Entry No." := rec.Count + 1; //maybe thats too much    
        rec."Item No." := _itemNo;
        rec."Group Code 1" := _groupCode1;
        rec."Group Code 2" := _groupCode2;
        rec."Group Code 3" := _groupCode3;
        rec."Group Description 1" := _groupDesc1;
        rec."Group Description 2" := _groupText2;
        rec."Group Description 3" := _groupText3;
        rec.insert();
        // g_counter += 1;
    end;

    var
        g_counter: integer;
}
