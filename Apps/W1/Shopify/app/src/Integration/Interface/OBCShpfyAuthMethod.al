namespace app.app;
using Microsoft.Integration.Shopify;

interface "OBC Shpfy Auth. Method"
{
    procedure GetAuthToken(shpfyshop: Record "Shpfy Shop"; var authToken: secrettext): Boolean;

}
