namespace app.app;

enum 88068 "OBC Shpfy Auth Method Type" implements "OBC Shpfy Auth. Method"
{
    Extensible = true;

    value(0; "Token (default)")
    {
        Caption = 'Token (standard)';
        Implementation = "OBC Shpfy Auth. Method" = "OBC Shpfy Auth Method - Token";
    }
}
