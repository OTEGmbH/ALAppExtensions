namespace Microsoft.Integration.Shopify;

codeunit 88050 "Shpfy OpenDoc NotSupported" implements "Shpfy IOpenShopifyDocument"
{

    procedure OpenDocument(DocumentId: BigInteger)
    var
        NotSupportedErr: Label 'Not Supported';
    begin
        Error(NotSupportedErr);
    end;

}