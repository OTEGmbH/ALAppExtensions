namespace app.app;
using System.Text;
using OTE.Shopify;

report 88021 "Shpfy Sync Catalog w.o Company"
{
    ApplicationArea = All;
    Caption = 'Shopify Sync Catalogs';
    UsageCategory = Tasks;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Shop; "Shpfy Shop")
        {
            RequestFilterFields = Code;

            trigger OnAfterGetRecord()
            begin
                CatalogAPI.SetShop(Shop);
                CatalogAPI.GetCatalogsWithoutCompany();
            end;
        }
    }

    var
        CatalogAPI: Codeunit "Shpfy Catalog API";
        RunForOneCompany: Boolean;
        CompanyId: BigInteger;

    internal procedure SetCompany(ShopifyCompany: Record "Shpfy Company")
    begin
        CompanyId := ShopifyCompany.Id;
        Shop.Get(ShopifyCompany."Shop Code");
        CatalogAPI.SetShop(Shop);
    end;
}
