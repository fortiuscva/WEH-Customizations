namespace WEHCustomizations.WEHCustomizations;

using Microsoft.Finance.VAT.Setup;
using Microsoft.Sales.Document;
using Microsoft.Foundation.Enums;

report 52100 "WEH Update VAT Calc. Type"
{
    ApplicationArea = All;
    Caption = 'Update VAT Calculation Type';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem(VATPostingSetup; "VAT Posting Setup")
        {
            DataItemTableView = where("VAT Calculation Type" = filter(0));
            trigger OnAfterGetRecord()
            begin
                VATPostingSetup.Validate("VAT Calculation Type", VATPostingSetup."VAT Calculation Type"::"Sales Tax");
                VATPostingSetup.Modify();
            end;
        }

        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = where("Document Type" = const(order));
            trigger OnAfterGetRecord()
            var
                SalesLine: Record "Sales Line";
                ReleaseSalesDoc: Codeunit "Release Sales Document";
                ReleasedOrder: Boolean;
            begin
                Clear(ReleasedOrder);
                if "Sales Header".Status = "Sales Header".Status::Released then begin
                    ReleaseSalesDoc.PerformManualReopen("Sales Header");
                    ReleasedOrder := true;
                end;


                SalesLine.Reset();
                SalesLine.SetRange("Document Type", "Sales Header"."Document Type");
                SalesLine.SetRange("Document No.", "Sales Header"."No.");
                SalesLine.SetFilter(Type, '<>%1', SalesLine.Type::" ");
                SalesLine.SetRange("VAT Calculation Type", SalesLine."VAT Calculation Type"::"Normal VAT");
                if SalesLine.FindSet() then
                    repeat
                        SalesLine.Validate("VAT Calculation Type", SalesLine."VAT Calculation Type"::"Sales Tax");
                        SalesLine.Modify();
                    until SalesLine.Next() = 0;

                if ReleasedOrder then
                    "Sales Header".PerformManualRelease();
            end;
        }

    }

    trigger OnPostReport()
    begin
        Message('Processed Successfully');
    end;
}
