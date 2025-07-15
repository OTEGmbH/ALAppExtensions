namespace OTE.Shopify;

/// <summary>
/// Unknown Shpfy D365 BASIC (ID 30100) extends Record D365 BASIC.
/// </summary>
using System.Security.AccessControl;

permissionsetextension 88000 "OTEShpfy D365 BASIC" extends "D365 BASIC"
{
    IncludedPermissionSets = "OTEShpfy - Read";

    Permissions = tabledata "Shpfy Doc. Link To Doc." = imd;
}
