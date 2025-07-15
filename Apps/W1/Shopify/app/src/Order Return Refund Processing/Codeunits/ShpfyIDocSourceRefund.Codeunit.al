namespace OTE.Shopify;

codeunit 88253 "Shpfy IDocSource Refund" implements "Shpfy IDocument Source"
{
    procedure SetErrorInfo(SourceDocumentId: BigInteger; ErrorDescription: Text)
    var
        RefundHeader: Record "Shpfy Refund Header";
    begin
        if RefundHeader.Get(SourceDocumentId) then
            RefundHeader.SetLastErrorDescription(ErrorDescription);
    end;
}