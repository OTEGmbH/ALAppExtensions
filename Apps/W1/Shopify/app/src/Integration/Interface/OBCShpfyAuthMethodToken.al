namespace app.app;

using Microsoft.Integration.Shopify;

codeunit 88299 "OBC Shpfy Auth Method - Token" implements "OBC Shpfy Auth. Method"
{
    procedure GetAuthToken(shpfyshop: Record "Shpfy Shop"; var authToken: SecretText): Boolean
    begin
        authToken := shpfyshop."Shop Access Token";
        exit(shpfyshop."Shop Access Token" <> '');
    end;
}
