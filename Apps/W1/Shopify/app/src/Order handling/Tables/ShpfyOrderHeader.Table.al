namespace OTE.Shopify;

using System.IO;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Document;
using Microsoft.Bank.BankAccount;
using Microsoft.Foundation.Shipping;
using System.Reflection;
using app.app;

/// <summary>
/// Table Shpfy Order Header (ID 30118).
/// </summary>
table 88032 "Shpfy Order Header"
{
    Caption = 'Shopify Order Header', comment = 'de-DE=Shopify Auftragskopf';
    DataCaptionFields = "Shopify Order No.", "Sell-to Customer Name";
    DataClassification = SystemMetadata;
    DrillDownPageID = "Shpfy Orders";
    LookupPageID = "Shpfy Orders";

    fields
    {
        field(1; "Shopify Order Id"; BigInteger)
        {
            DataClassification = SystemMetadata;
        }
        field(2; Email; Text[80])
        {
            Caption = 'Email', comment = 'de-DE=E-Mail';
            DataClassification = CustomerContent;
            ExtendedDatatype = EMail;
        }
        field(5; "Sell-to Address"; Text[100])
        {
            Caption = 'Sell-to Address', comment = 'de-DE=Verkauf an Adresse';
            DataClassification = CustomerContent;
        }
        field(6; "Sell-to Address 2"; Text[100])
        {
            Caption = 'Sell-to Address 2', comment = 'de-DE=Verkauf an Adresse 2';
            DataClassification = CustomerContent;
        }
        field(7; "Sell-to City"; Text[50])
        {
            Caption = 'Sell-to City', comment = 'de-DE=Verkauf an Ort';
            DataClassification = CustomerContent;
        }
        field(8; "Sell-to Post Code"; Text[50])
        {
            Caption = 'Sell-to Post Code', comment = 'de-DE=Verkauf an PLZ';
            DataClassification = CustomerContent;
        }
        field(9; "Sell-to Country/Region Code"; Code[20])
        {
            Caption = 'Sell-to Country/Region Code', comment = 'de-DE=Verkauf an Länder-/Regionscode';
            DataClassification = CustomerContent;
        }
        field(10; "Sell-to Country/Region Name"; Text[50])
        {
            Caption = 'Sell-to Country/Region Name', comment = 'de-DE=Verkauf an Länder-/Regionsname';
            DataClassification = CustomerContent;
        }
        field(11; "Phone No."; Text[50])
        {
            Caption = 'Phone No.', comment = 'de-DE=Telefonnr.';
            DataClassification = CustomerContent;
            ExtendedDatatype = PhoneNo;
        }
#if not CLEANSCHEMA25
        field(12; Token; Text[50])
        {
            Caption = 'Token', comment = 'de-DE=Token';
            DataClassification = CustomerContent;
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteTag = '25.0';
            ObsoleteReason = 'Not available in GraphQL data.';
        }
#endif
        field(13; Gateway; Text[50])
        {
            Caption = 'Gateway', comment = 'de-DE=Gateway';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14; "Sell-to First Name"; Text[50])
        {
            Caption = 'Sell-to First Name', comment = 'de-DE=Verkauf an Vorname';
            DataClassification = CustomerContent;
        }
        field(15; "Sell-to Last Name"; Text[50])
        {
            Caption = 'Sell-to Last Name', comment = 'de-DE=Verkauf an Nachname';
            DataClassification = CustomerContent;
        }
#if not CLEANSCHEMA25
        field(16; Currency; Code[10])
        {
            Caption = 'Currency', comment = 'de-DE=Währung';
            DataClassification = Customercontent;
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteTag = '25.0';
            ObsoleteReason = 'Replaced with the fields "Currency Code" and "Presentment Currency Code".';
        }
        field(17; "Cart Token"; Text[50])
        {
            Caption = 'Cart Token', comment = 'de-DE=Warenkorb Token';
            DataClassification = CustomerContent;
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteTag = '25.0';
            ObsoleteReason = 'Not available in GraphQL data.';
        }
        field(18; "Checkout Token"; Text[50])
        {
            Caption = 'Checkout Token', comment = 'de-DE=Checkout Token';
            DataClassification = CustomerContent;
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteTag = '25.0';
            ObsoleteReason = 'Not available in GraphQL data.';
        }
        field(19; Reference; Text[50])
        {
            Caption = 'Reference', comment = 'de-DE=Referenz';
            DataClassification = CustomerContent;
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteTag = '25.0';
            ObsoleteReason = 'Not available in GraphQL data.';
        }
#endif
#if not CLEANSCHEMA28
        field(21; "Risk Level"; Enum "Shpfy Risk Level")
        {
            Caption = 'Risk Level', comment = 'de-DE=Risikostufe';
            DataClassification = SystemMetadata;
            Editable = false;
            ObsoleteReason = 'This field is not imported. Use field "High Risk" field.';
#if not CLEAN25
            ObsoleteState = Pending;
            ObsoleteTag = '25.0';
#else
            ObsoleteState = Removed;
            ObsoleteTag = '28.0';
#endif
        }
#endif
        field(22; "Fully Paid"; Boolean)
        {
            Caption = 'Fully Paid', comment = 'de-DE=Vollständig bezahlt';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(23; "Processing Method"; Enum "Shpfy Processing Method")
        {
            Caption = 'Processing Method', comment = 'de-DE=Verarbeitungsmethode';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(24; "Checkout Id"; BigInteger)
        {
            Caption = 'Checkout Id', comment = 'de-DE=Checkout ID';
            DataClassification = SystemMetadata;
            Editable = false;
        }
#if not CLEANSCHEMA25
        field(25; "Contact Email"; Text[100])
        {
            Caption = 'Contact Email', comment = 'de-DE=Kontakt E-Mail';
            DataClassification = CustomerContent;
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteTag = '25.0';
            ObsoleteReason = 'Not available in GraphQL data.';
        }
#endif
        field(26; "Total Tip Received"; Decimal)
        {
            Caption = 'Total Tip Received', comment = 'de-DE=Trinkgeld erhalten gesamt';
            DataClassification = SystemMetadata;
            Editable = false;
        }
#if not CLEANSCHEMA25
        field(27; "Session Hash"; Text[50])
        {
            Caption = 'Session Hash', comment = 'de-DE=Session Hash';
            DataClassification = SystemMetadata;
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteTag = '25.0';
            ObsoleteReason = 'Not available in GraphQL data.';
        }
#endif
        field(48; "Ship-to First Name"; Text[50])
        {
            Caption = 'Ship-to First Name', comment = 'de-DE=Lieferung an Vorname';
            DataClassification = CustomerContent;
        }
        field(49; "Ship-to Last Name"; Text[50])
        {
            Caption = 'Ship-to Last Name', comment = 'de-DE=Lieferung an Nachname';
            DataClassification = CustomerContent;
        }
        field(50; "Ship-to Name"; Text[50])
        {
            Caption = 'Ship-to Name', comment = 'de-DE=Lieferung an Name';
            DataClassification = CustomerContent;
        }
        field(51; "Ship-to Address"; Text[100])
        {
            Caption = 'Ship-to Address', comment = 'de-DE=Lieferung an Adresse';
            DataClassification = CustomerContent;
        }
        field(52; "Ship-to Address 2"; Text[100])
        {
            Caption = 'Ship-to Address 2', comment = 'de-DE=Lieferung an Adresse 2';
            DataClassification = CustomerContent;
        }
        field(53; "Ship-to City"; Text[50])
        {
            Caption = 'Ship-to City', comment = 'de-DE=Lieferung an Ort';
            DataClassification = CustomerContent;
        }
        field(54; "Ship-to Post Code"; Text[50])
        {
            Caption = 'Ship-to Post Code', comment = 'de-DE=Lieferung an PLZ';
            DataClassification = CustomerContent;
        }
        field(55; "Ship-to Country/Region Code"; Code[20])
        {
            Caption = 'Ship-to Country/Region Code', comment = 'de-DE=Lieferung an Länder-/Regionscode';
            DataClassification = CustomerContent;
        }
        field(56; "Ship-to Country/Region Name"; Text[50])
        {
            Caption = 'Ship-to Country/Region Name', comment = 'de-DE=Lieferung an Länder-/Regionsname';
            DataClassification = CustomerContent;
        }
        field(57; "Ship-to Latitude"; Decimal)
        {
            Caption = 'Ship-to Latitude', comment = 'de-DE=Lieferung an Breitengrad';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(58; "Ship-to Longitude"; Decimal)
        {
            Caption = 'Ship-to Longitude', comment = 'de-DE=Lieferung an Längengrad';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60; "Bill-to Name"; Text[50])
        {
            Caption = 'Bill-to Name', comment = 'de-DE=Rechnung an Name';
            DataClassification = CustomerContent;
        }
        field(61; "Bill-to Address"; Text[100])
        {
            Caption = 'Bill-to Address', comment = 'de-DE=Rechnung an Adresse';
            DataClassification = CustomerContent;
        }
        field(62; "Bill-to Address 2"; Text[100])
        {
            Caption = 'Bill-to Address 2', comment = 'de-DE=Rechnung an Adresse 2';
            DataClassification = CustomerContent;
        }
        field(63; "Bill-to City"; Text[50])
        {
            Caption = 'Bill-to City', comment = 'de-DE=Rechnung an Ort';
            DataClassification = CustomerContent;
        }
        field(64; "Bill-to Post Code"; Text[50])
        {
            Caption = 'Bill-to Post Code', comment = 'de-DE=Rechnung an PLZ';
            DataClassification = CustomerContent;
        }
        field(65; "Bill-to Country/Region Code"; Code[20])
        {
            Caption = 'Bill-to Country/Region Code', comment = 'de-DE=Rechnung an Länder-/Regionscode';
            DataClassification = CustomerContent;
        }
        field(66; "Bill-to Country/Region Name"; Text[50])
        {
            Caption = 'Bill-to Country/Region Name', comment = 'de-DE=Rechnung an Länder-/Regionsname';
            DataClassification = CustomerContent;
        }
        field(67; Test; Boolean)
        {
            Caption = 'Test', comment = 'de-DE=Test';
            DataClassification = SystemMetadata;
        }
        field(68; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount', comment = 'de-DE=Gesamtbetrag';
            DataClassification = SystemMetadata;
        }
        field(69; "Subtotal Amount"; Decimal)
        {
            Caption = 'Subtotal Amount', comment = 'de-DE=Zwischensumme';
            DataClassification = SystemMetadata;
        }
        field(70; "Total Weight"; Decimal)
        {
            Caption = 'Total Weight', comment = 'de-DE=Gesamtgewicht';
            DataClassification = SystemMetadata;
        }
        field(71; "VAT Amount"; Decimal)
        {
            Caption = 'VAT Amount', comment = 'de-DE=MwSt.-Betrag';
            DataClassification = SystemMetadata;
        }
        field(72; "VAT Included"; Boolean)
        {
            Caption = 'VAT Included', comment = 'de-DE=MwSt. enthalten';
            DataClassification = SystemMetadata;

            trigger OnValidate()
            begin
                if "VAT Amount" <> 0 then
                    Error(VATAmountMustBeZeroErr);
            end;
        }
        field(73; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code', comment = 'de-DE=Währungscode';
            DataClassification = SystemMetadata;
        }
        field(74; "Financial Status"; Enum "Shpfy Financial Status")
        {
            Caption = 'Financial Status', comment = 'de-DE=Finanzstatus';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(75; Confirmed; Boolean)
        {
            Caption = 'Confirmed', comment = 'de-DE=Bestätigt';
            DataClassification = SystemMetadata;
        }
        field(76; "Discount Amount"; Decimal)
        {
            Caption = 'Discount Amount', comment = 'de-DE=Rabattbetrag';
            DataClassification = SystemMetadata;
        }
        field(77; "Total Items Amount"; Decimal)
        {
            Caption = 'Total Items Amount', comment = 'de-DE=Gesamtbetrag Artikel';
            DataClassification = SystemMetadata;
        }
        field(78; "Fulfillment Status"; Enum "Shpfy Order Fulfill. Status")
        {
            Caption = 'Fulfillment Status', comment = 'de-DE=Erfüllungsstatus';
            DataClassification = SystemMetadata;
            Editable = false;
        }
#if not CLEANSCHEMA25
        field(79; "Buyer Accepts Marketing"; Boolean)
        {
            Caption = 'Buyer Accepts Marketing', comment = 'de-DE=Käufer akzeptiert Marketing';
            DataClassification = SystemMetadata;
            ObsoleteState = Removed;
            ObsoleteTag = '25.0';
            ObsoleteReason = 'Not available in GraphQL data.';
        }
#endif
        field(80; "Cancelled At"; DateTime)
        {
            Caption = 'Cancelled At', comment = 'de-DE=Storniert am';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(81; "Cancel Reason"; Enum "Shpfy Cancel Reason")
        {
            Caption = 'Cancel Reason', comment = 'de-DE=Stornierungsgrund';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(82; "Closed At"; DateTime)
        {
            Caption = 'Closed At', comment = 'de-DE=Geschlossen am';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(83; "Bill-to First Name"; Text[50])
        {
            Caption = 'Bill-to First Name', comment = 'de-DE=Rechnung an Vorname';
            DataClassification = CustomerContent;
        }
        field(84; "Bill-to Lastname"; Text[50])
        {
            Caption = 'Bill-to Last Name', comment = 'de-DE=Rechnung an Nachname';
            DataClassification = CustomerContent;
        }
        field(87; "Processed At"; DateTime)
        {
            Caption = 'Processed At', comment = 'de-DE=Verarbeitet am';
            DataClassification = SystemMetadata;
        }
        field(89; "Shopify Order No."; Text[50])
        {
            Caption = 'Shopify Order No.', comment = 'de-DE=Shopify Auftragsnr.';
            DataClassification = SystemMetadata;
        }
        field(90; "Order Status URL"; Text[250])
        {
            Caption = 'Order Status URL', comment = 'de-DE=Auftragsstatus-URL';
            DataClassification = SystemMetadata;
            ExtendedDatatype = URL;
        }
        field(91; "Created At"; DateTime)
        {
            Caption = 'Created At', comment = 'de-DE=Erstellt am';
            DataClassification = SystemMetadata;
        }
        field(92; "Source Name"; Code[20])
        {
            Caption = 'Source Name', comment = 'de-DE=Quellenname';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(93; "Updated At"; DateTime)
        {
            Caption = 'Updated At', comment = 'de-DE=Aktualisiert am';
            DataClassification = SystemMetadata;
        }
        field(94; "Shipping Charges Amount"; Decimal)
        {
            Caption = 'Shipping Charges Amount', comment = 'de-DE=Versandkostenbetrag';
            DataClassification = SystemMetadata;
        }
        field(95; "Document Date"; Date)
        {
            Caption = 'Document Date', comment = 'de-DE=Belegdatum';
            DataClassification = SystemMetadata;

            trigger OnValidate();
            begin
                TestField("Sales Order No.", '');
            end;
        }
        field(96; "Sell-to County"; Text[30])
        {
            Caption = 'Sell-to County', comment = 'de-DE=Verkauf an Bezirk';
            DataClassification = CustomerContent;
        }
        field(97; "Bill-to County"; Text[30])
        {
            Caption = 'Bill-to County', comment = 'de-DE=Rechnung an Bezirk';
            DataClassification = CustomerContent;
        }
        field(98; "Ship-to County"; Text[30])
        {
            Caption = 'Ship-to County', comment = 'de-DE=Lieferung an Bezirk';
            DataClassification = CustomerContent;
        }
        field(99; "Customer Id"; BigInteger)
        {
            Caption = 'Customer Id', comment = 'de-DE=Kunden-ID';
            DataClassification = CustomerContent;
        }
        field(100; Closed; Boolean)
        {
            Caption = 'Closed', comment = 'de-DE=Geschlossen';
            DataClassification = SystemMetadata;
            Editable = false;
        }
#if not CLEANSCHEMA28
        field(101; "Location Id"; BigInteger)
        {
            Caption = 'Location Id', comment = 'de-DE=Standort-ID';
            DataClassification = CustomerContent;
            Editable = false;
            ObsoleteReason = 'Location Id on Order Header is not used. Instead use Location Id on Order Lines.';
#if not CLEAN25
            ObsoleteState = Pending;
            ObsoleteTag = '25.0';
#else
            ObsoleteState = Removed;
            ObsoleteTag = '28.0';
#endif
        }
#endif
        field(102; "Channel Name"; Text[100])
        {
            Caption = 'Channel Name', comment = 'de-DE=Kanalname';
            Editable = false;
        }
        field(103; "App Name"; Text[100])
        {
            Caption = 'App Name', comment = 'de-DE=App-Name';
            Editable = false;
        }
        field(104; "Presentment Currency Code"; Code[10])
        {
            Caption = 'Presentment Currency Code', comment = 'de-DE=Darstellungswährungscode';
            Editable = false;
        }
        field(105; Unpaid; Boolean)
        {
            Caption = 'Unpaid', comment = 'de-DE=Unbezahlt';
            Editable = false;
        }
        field(106; "Discount Code"; Code[20])
        {
            Caption = 'Discount Code', comment = 'de-DE=Rabattcode';
            Editable = false;
        }
        field(107; "Discount Codes"; Text[250])
        {
            Caption = 'Discount Codes', comment = 'de-DE=Rabattcodes';
            Editable = false;
        }
        field(108; Refundable; Boolean)
        {
            Caption = 'Refundable', comment = 'de-DE=Erstattungsfähig';
            Editable = false;
        }
        field(109; "Presentment Total Amount"; Decimal)
        {
            Caption = 'Presentment Total Amount', comment = 'de-DE=Darstellung Gesamtbetrag';
            DataClassification = SystemMetadata;
        }
        field(110; "Presentment Subtotal Amount"; Decimal)
        {
            Caption = 'Presentment Subtotal Amount', comment = 'de-DE=Darstellung Zwischensumme';
            DataClassification = SystemMetadata;
        }
        field(111; "Presentment VAT Amount"; Decimal)
        {
            Caption = 'Presentment VAT Amount', comment = 'de-DE=Darstellung MwSt.-Betrag';
            DataClassification = SystemMetadata;
        }
        field(112; "Presentment Discount Amount"; Decimal)
        {
            Caption = 'Discount Amount', comment = 'de-DE=Darstellung Rabattbetrag';
            DataClassification = SystemMetadata;
        }
        field(113; "Presentment Total Tip Received"; Decimal)
        {
            Caption = 'Presentment Total Tip Received', comment = 'de-DE=Darstellung Trinkgeld erhalten gesamt';
            DataClassification = SystemMetadata;
        }
        field(114; "Pres. Shipping Charges Amount"; Decimal)
        {
            Caption = 'Presentment Shipping Charges Amount', comment = 'de-DE=Darstellung Versandkostenbetrag';
            DataClassification = SystemMetadata;
        }
        field(115; Edited; Boolean)
        {
            Caption = 'Edited', comment = 'de-DE=Bearbeitet';
            DataClassification = SystemMetadata;
        }
        field(116; "Return Status"; Enum "Shpfy Order Return Status")
        {
            Caption = 'Return Status', comment = 'de-DE=Rückgabestatus';
            DataClassification = SystemMetadata;
        }
        field(117; "Company Id"; BigInteger)
        {
            Caption = 'Company Id', comment = 'de-DE=Unternehmen-ID';
            DataClassification = SystemMetadata;
        }
        field(118; "Company Main Contact Id"; BigInteger)
        {
            Caption = 'Company Main Contact Id', comment = 'de-DE=Unternehmen Hauptkontakt-ID';
            DataClassification = SystemMetadata;
        }
        field(119; "Company Main Contact Email"; Text[100])
        {
            Caption = 'Company Main Contact Email', comment = 'de-DE=Unternehmen Hauptkontakt E-Mail';
            DataClassification = SystemMetadata;
        }
        field(120; "Company Main Contact Phone No."; Text[50])
        {
            Caption = 'Company Main Contact Phone No.', comment = 'de-DE=Unternehmen Hauptkontakt Telefonnr.';
            DataClassification = SystemMetadata;
            ExtendedDatatype = PhoneNo;
        }
        field(121; "Company Main Contact Cust. Id"; BigInteger)
        {
            Caption = 'Company Main Contact Customer Id', comment = 'de-DE=Unternehmen Hauptkontakt Kunden-ID';
            DataClassification = SystemMetadata;
        }
        field(122; B2B; Boolean)
        {
            Caption = 'B2B', comment = 'de-DE=B2B';
            DataClassification = SystemMetadata;
        }
        field(123; "Current Total Amount"; Decimal)
        {
            Caption = 'Current Total Amount', comment = 'de-DE=Aktueller Gesamtbetrag';
            DataClassification = SystemMetadata;
        }
        field(124; "Current Total Items Quantity"; Integer)
        {
            Caption = 'Current Total Items Quantity', comment = 'de-DE=Aktuelle Gesamtanzahl Artikel';
            DataClassification = SystemMetadata;
        }
        field(125; "Line Items Redundancy Code"; Integer)
        {
            Caption = 'Line Items Redundancy Code', comment = 'de-DE=Artikel Redundanzcode';
            DataClassification = SystemMetadata;
        }
        field(126; "PO Number"; Text[512])
        {
            Caption = 'PO Number', comment = 'de-DE=Bestellnummer';
            DataClassification = SystemMetadata;
        }
        field(127; "Company Location Id"; BigInteger)
        {
            Caption = 'Company Location Id', comment = 'de-DE=Unternehmen Standort-ID';
            DataClassification = SystemMetadata;
        }
        field(128; "High Risk"; Boolean)
        {
            Caption = 'High Risk', comment = 'de-DE=Hohes Risiko';
            FieldClass = FlowField;
            CalcFormula = exist("Shpfy Order Risk" where("Order Id" = field("Shopify Order Id"), Level = const(High)));
        }
        field(129; "Due Date"; Date)
        {
            Caption = 'Due Date', comment = 'de-DE=Fälligkeitsdatum';
            DataClassification = CustomerContent;
        }
        field(130; "Pres. Payment Rounding Amount"; Decimal)
        {
            Caption = 'Presentment Payment Rounding Amount';
            DataClassification = SystemMetadata;
            AutoFormatType = 1;
            AutoFormatExpression = "Presentment Currency Code";
        }
        field(131; "Payment Rounding Amount"; Decimal)
        {
            Caption = 'Payment Rounding Amount';
            DataClassification = SystemMetadata;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";
        }
        field(132; "Pres. Refund Rounding Amount"; Decimal)
        {
            Caption = 'Presentment Refund Rounding Amount';
            DataClassification = SystemMetadata;
            AutoFormatType = 1;
            AutoFormatExpression = "Presentment Currency Code";
        }
        field(133; "Refund Rounding Amount"; Decimal)
        {
            Caption = 'Refund Rounding Amount';
            DataClassification = SystemMetadata;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";
        }
        field(500; "Shop Code"; Code[20])
        {
            Caption = 'Shop Code', comment = 'de-DE=Shop-Code';
            DataClassification = SystemMetadata;
            TableRelation = "Shpfy Shop";
        }
#if not CLEANSCHEMA25
        field(501; "Customer Template Code"; Code[10])
        {
            Caption = 'Customer Template Code', comment = 'de-DE=Debitorenvorlagencode';
            DataClassification = SystemMetadata;
            TableRelation = "Config. Template Header".Code where("Table Id" = const(18));
            ObsoleteReason = 'Replaced by Customer Templ. Code';
            ObsoleteState = Removed;
            ObsoleteTag = '25.0';
        }
#endif
        field(502; "Customer Templ. Code"; Code[20])
        {
            Caption = 'Customer Template Code', comment = 'de-DE=Debitorenvorlagencode';
            DataClassification = SystemMetadata;
            TableRelation = "Customer Templ.".Code;
        }
        field(601; "Total Quantity of Items"; Decimal)
        {
            Caption = 'Total Quantity of Items', comment = 'de-DE=Gesamtmenge Artikel';
            FieldClass = FlowField;
            CalcFormula = sum("Shpfy Order Line".Quantity where("Shopify Order Id" = field("Shopify Order Id"), "Gift Card" = const(false), Tip = const(false)));
        }
        field(602; "Number of Lines"; Integer)
        {
            Caption = 'Number of Lines', comment = 'de-DE=Anzahl Zeilen';
            FieldClass = FlowField;
            CalcFormula = Count("Shpfy Order Line" where("Shopify Order Id" = field("Shopify Order Id")));
        }
        field(1000; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.', comment = 'de-DE=Verkauf an Debitorennr.';
            DataClassification = SystemMetadata;
            TableRelation = Customer;
        }
        field(1001; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.', comment = 'de-DE=Verkaufsauftragsnr.';
            DataClassification = SystemMetadata;
            TableRelation = "Sales Header"."No." where("Document Type" = const(Order));
        }
        field(1002; "Has Error"; Boolean)
        {
            Caption = 'Has Error', comment = 'de-DE=Hat Fehler';
            DataClassification = SystemMetadata;
        }
        field(1003; "Error Message"; Text[2048])
        {
            Caption = 'Error Message', comment = 'de-DE=Fehlermeldung';
            DataClassification = SystemMetadata;
        }
        field(1004; Processed; Boolean)
        {
            Caption = 'Processed', comment = 'de-DE=Verarbeitet';
            DataClassification = SystemMetadata;
        }
        field(1005; "Sell-to Customer Name"; Text[50])
        {
            Caption = 'Sell-to Customer Name', comment = 'de-DE=Verkauf an Debitorenname';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                Customer: Record Customer;
            begin
                Validate("Sell-to Customer No.", Customer.GetCustNo("Sell-to Customer Name"));
            end;
        }

        field(1006; "Sales Invoice No."; Code[20])
        {
            Caption = 'Sales Invoice No.', comment = 'de-DE=Verkaufsrechnungsnr.';
            DataClassification = SystemMetadata;
            TableRelation = "Sales Header"."No." where("Document Type" = const(Invoice));
        }
        field(1007; "Work Description"; Blob)
        {
            Caption = 'Work Description', comment = 'de-DE=Arbeitsbeschreibung';
            DataClassification = SystemMetadata;
        }
        field(1008; "Sell-to Customer Name 2"; Text[50])
        {
            Caption = 'Sell-to Customer Name 2', comment = 'de-DE=Verkauf an Debitorenname 2';
            DataClassification = CustomerContent;
        }
        field(1009; "Ship-to Name 2"; Text[50])
        {
            Caption = 'Ship-to Name 2', comment = 'de-DE=Lieferung an Name 2';
            DataClassification = CustomerContent;
        }
        field(1010; "Bill-to Name 2"; Text[50])
        {
            Caption = 'Bill-to Name 2', comment = 'de-DE=Rechnung an Name 2';
            DataClassification = CustomerContent;
        }
        field(1011; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.', comment = 'de-DE=Rechnung an Debitorennr.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(1012; "Shipping Method Code"; Code[10])
        {
            Caption = 'Shipping Method Code', comment = 'de-DE=Versandartcode';
            DataClassification = CustomerContent;
            TableRelation = "Shipment Method";
        }
        field(1013; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code', comment = 'de-DE=Zahlungsformcode';
            DataClassification = CustomerContent;
            TableRelation = "Payment Method";
        }
        field(1014; "Sell-to Contact Name"; Text[100])
        {
            Caption = 'Sell-to Contact Name', comment = 'de-DE=Verkauf an Kontaktname';
            DataClassification = CustomerContent;
        }
        field(1015; "Bill-to Contact Name"; Text[100])
        {
            Caption = 'Bill-to Contact Name', comment = 'de-DE=Rechnung an Kontaktname';
            DataClassification = CustomerContent;
        }
        field(1016; "Ship-to Contact Name"; Text[100])
        {
            Caption = 'Ship-to Contact Name', comment = 'de-DE=Lieferung an Kontaktname';
            DataClassification = CustomerContent;
        }
        field(1017; "Sell-to Contact No."; Code[20])
        {
            Caption = 'Sell-to Contact No.', comment = 'de-DE=Verkauf an Kontaktnr.';
            DataClassification = CustomerContent;
        }
        field(1018; "Bill-to Contact No."; Code[20])
        {
            Caption = 'Bill-to Contact No.', comment = 'de-DE=Rechnung an Kontaktnr.';
            DataClassification = CustomerContent;
        }
        field(1019; "Ship-to Contact No."; Code[20])
        {
            Caption = 'Ship-to Contact No.', comment = 'de-DE=Lieferung an Kontaktnr.';
            DataClassification = CustomerContent;
        }
        field(1020; "Has Order State Error"; Boolean)
        {
            Caption = 'Has Order State Error', comment = 'de-DE=Hat Auftragsstatus-Fehler';
            DataClassification = SystemMetadata;
        }
        field(1021; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code', comment = 'de-DE=Zusteller-Code';
            TableRelation = "Shipping Agent";

            trigger OnValidate()
            begin
                if "Shipping Agent Code" <> xRec."Shipping Agent Code" then
                    Clear("Shipping Agent Service Code");
            end;
        }
        field(1022; "Shipping Agent Service Code"; Code[10])
        {
            Caption = 'Shipping Agent Service Code', comment = 'de-DE=Zustellerservicecode';
            TableRelation = "Shipping Agent Services".Code where("Shipping Agent Code" = field("Shipping Agent Code"));
        }
        field(1030; "Payment Terms Type"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Payment Terms Type', comment = 'de-DE=Zahlungsbedingungstyp';
        }
        field(1040; "Payment Terms Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Payment Terms Name', comment = 'de-DE=Zahlungsbedingungsname';
        }
        field(1050; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            DataClassification = CustomerContent;
        }
        field(1060; "Processed Currency Handling"; Enum "Shpfy Currency Handling")
        {
            Caption = 'Processed Currency Handling';
            DataClassification = SystemMetadata;
            Editable = false;
        }
    }
    keys
    {
        key(Key1; "Shopify Order Id")
        {
            Clustered = true;
        }
        key(Key2; "Shop Code", Processed)
        {

        }
    }
    var
        ShopifyOrderLine: Record "Shpfy Order Line";
        VATAmountMustBeZeroErr: Label 'VAT amount must be 0 in order to update VAT included.';

    trigger OnDelete()
    var
        ShopifyReturnHeader: Record "Shpfy Return Header";
        ShopifyRefundHeader: Record "Shpfy Refund Header";
        DataCapture: Record "Shpfy Data Capture";
        FulfillmentOrderHeader: Record "Shpfy FulFillment Order Header";
        OrderFulfillment: Record "Shpfy Order Fulfillment";
    begin
        ShopifyOrderLine.SetRange("Shopify Order Id", "Shopify Order Id");
        if not ShopifyOrderLine.IsEmpty then
            ShopifyOrderLine.DeleteAll(true);
        ShopifyReturnHeader.SetRange("Order Id", "Shopify Order Id");
        if not ShopifyReturnHeader.IsEmpty then
            ShopifyReturnHeader.DeleteAll(true);
        ShopifyRefundHeader.SetRange("Order Id", "Shopify Order Id");
        if not ShopifyRefundHeader.IsEmpty then
            ShopifyRefundHeader.DeleteAll(true);
        DataCapture.SetCurrentKey("Linked To Table", "Linked To Id");
        DataCapture.SetRange("Linked To Table", Database::"Shpfy Order Header");
        DataCapture.SetRange("Linked To Id", Rec.SystemId);
        if not DataCapture.IsEmpty then
            DataCapture.DeleteAll(false);

        FulfillmentOrderHeader.SetRange("Shopify Order Id", Rec."Shopify Order Id");
        if not FulfillmentOrderHeader.IsEmpty then
            FulfillmentOrderHeader.DeleteAll(true);

        OrderFulfillment.SetRange("Shopify Order Id", Rec."Shopify Order Id");
        if not OrderFulfillment.IsEmpty then
            OrderFulfillment.DeleteAll(true);
    end;

    /// <summary> 
    /// Get Work Description.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    internal procedure GetWorkDescription(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("Work Description");
        "Work Description".CreateInStream(InStream, TextEncoding::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator()));
    end;

    /// <summary> 
    /// Set Work Description.
    /// </summary>
    /// <param name="NewWorkDescription">Parameter of type Text.</param>
    internal procedure SetWorkDescription(NewWorkDescription: Text)
    var
        OutStream: OutStream;
    begin
        Clear("Work Description");
        "Work Description".CreateOutStream(OutStream, TextEncoding::UTF8);
        OutStream.WriteText(NewWorkDescription);
        Modify();
    end;

    /// <summary> 
    /// Update Tags.
    /// </summary>
    /// <param name="CommaSeperatedTags">Parameter of type Text.</param>
    internal procedure UpdateTags(CommaSeperatedTags: Text)
    var
        ShopifyTag: Record "Shpfy Tag";
    begin
        ShopifyTag.UpdateTags(Database::"Shpfy Order Header", "Shopify Order Id", CommaSeperatedTags);
    end;

    internal procedure IsProcessed(): Boolean
    var
        DocLinkToBCDoc: Record "Shpfy Doc. Link To Doc.";
    begin
        DocLinkToBCDoc.SetRange("Shopify Document Type", "Shpfy Shop Document Type"::"Shopify Shop Order");
        DocLinkToBCDoc.SetRange("Shopify Document Id", Rec."Shopify Order Id");
        DocLinkToBCDoc.SetCurrentKey("Shopify Document Type", "Shopify Document Id");
        exit(Rec.Processed or not DocLinkToBCDoc.IsEmpty);
    end;

}
