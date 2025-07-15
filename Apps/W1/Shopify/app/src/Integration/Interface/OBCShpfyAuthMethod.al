namespace app.app;
using OTE.Shopify;

interface "OBC Shpfy Auth. Method"
{
    procedure GetAuthToken(shpfyshop: Record "Shpfy Shop"; var authToken: secrettext): Boolean;

}
