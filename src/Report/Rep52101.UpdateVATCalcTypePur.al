namespace WEHCustomizations.WEHCustomizations;

using Microsoft.Finance.VAT.Setup;
using Microsoft.Purchases.Document;
using Microsoft.Finance.VAT.Ledger;
using Microsoft.Foundation.Enums;

report 52101 "WEH Update VAT Calc. Type Pur."
{
    ApplicationArea = All;
    Caption = 'Update VAT Calculation Type Purchase';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            trigger OnAfterGetRecord()
            var
                PurchaseLine: Record "Purchase Line";
                ReleasePurchaseDoc: Codeunit "Release Purchase Document";
                ReleasedOrder: Boolean;
            begin
                Clear(ReleasedOrder);
                if "Purchase Header".Status = "Purchase Header".Status::Released then begin
                    ReleasePurchaseDoc.PerformManualReopen("Purchase Header");
                    ReleasedOrder := true;
                end;

                PurchaseLine.Reset();
                PurchaseLine.SetRange("Document Type", "Purchase Header"."Document Type");
                PurchaseLine.SetRange("Document No.", "Purchase Header"."No.");
                PurchaseLine.SetFilter(Type, '<>%1', PurchaseLine.Type::" ");
                PurchaseLine.SetRange("VAT Calculation Type", PurchaseLine."VAT Calculation Type"::"Normal VAT");
                if PurchaseLine.FindSet() then
                    repeat
                        PurchaseLine.Validate("VAT Calculation Type", PurchaseLine."VAT Calculation Type"::"Sales Tax");
                        PurchaseLine.Modify();
                    until PurchaseLine.Next() = 0;

                if ReleasedOrder then
                    "Purchase Header".PerformManualRelease();
            end;
        }
    }
    trigger OnPostReport()
    begin
        Message('Processed Successfully');
    end;

}
