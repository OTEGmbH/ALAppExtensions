table 88064 "Shpfy OTE Setup"
{
    Caption = 'Shpfy OTE Setup';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; Primary; Code[20])
        {
            Caption = 'Primary';
        }
        field(10; "Get Metafield Values"; Boolean)
        {
            Caption = 'Get Metafield Values';
        }
    }
    keys
    {
        key(PK; Primary)
        {
            Clustered = true;
        }
    }
}
