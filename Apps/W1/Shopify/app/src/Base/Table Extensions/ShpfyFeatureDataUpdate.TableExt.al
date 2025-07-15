#if not CLEANSCHEMA25
namespace OTE.Shopify;

using System.Environment.Configuration;

tableextension 88000 "Shpfy Feature Data Update" extends "Feature Data Update Status"
{
    fields
    {
        field(88000; "Shpfy Templates Migrate"; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Migrate Shopify templates';
            ObsoleteState = Removed;
            ObsoleteTag = '25.0';
            ObsoleteReason = 'Not used anymore.';
        }
    }
}
#endif