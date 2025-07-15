namespace OTE.Shopify;

/// <summary>
/// Shpfy - Admin Permissions (ID 30103).
/// </summary>
permissionset 88000 "OTEShpfy - Admin"
{
    Access = Public;
    Assignable = true;
    Caption = 'Shopify - Admin', MaxLength = 30;

    IncludedPermissionSets = "OTEShpfy - Edit";

    Permissions =
        tabledata "Shpfy Registered Store New" = IMD;
}