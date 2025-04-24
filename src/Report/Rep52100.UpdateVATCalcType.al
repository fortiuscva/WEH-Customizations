namespace WEHCustomizations.WEHCustomizations;

using Microsoft.Finance.VAT.Setup;
using Microsoft.Sales.Document;
using Microsoft.Service.Document;
using Microsoft.Finance.VAT.Ledger;
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
                VATPostingSetup."VAT Calculation Type" := VATPostingSetup."VAT Calculation Type"::"Sales Tax";
                VATPostingSetup.Modify();
            end;
        }

        dataitem("Sales Header"; "Sales Header")
        {
            //DataItemTableView = where("Document Type" = filter('Order|Quote'));
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
        dataitem("Service Header"; "Service Header")
        {
            trigger OnAfterGetRecord()
            var
                ServiceLine: Record "Service Line";
                ReleaseServiceDoc: Codeunit "Release Service Document";
                ReleasedServiceOrder: Boolean;
            begin
                Clear(ReleasedServiceOrder);
                if "Service Header"."Release Status" = "Service Header"."Release Status"::"Released to Ship" then begin
                    ReleaseServiceDoc.PerformManualReopen("Service Header");
                    ReleasedServiceOrder := true;
                end;

                ServiceLine.Reset();
                ServiceLine.SetRange("Document Type", "Service Header"."Document Type");
                ServiceLine.SetRange("Document No.", "Service Header"."No.");
                ServiceLine.SetFilter(Type, '<>%1', ServiceLine.Type::" ");
                ServiceLine.SetRange("VAT Calculation Type", ServiceLine."VAT Calculation Type"::"Normal VAT");
                if ServiceLine.FindSet() then
                    repeat
                        ServiceLine.Validate("VAT Calculation Type", ServiceLine."VAT Calculation Type"::"Sales Tax");
                        ServiceLine.Modify();
                    until ServiceLine.Next() = 0;

                if ReleasedServiceOrder then begin
                    if "Service Header"."Release Status" <> "Service Header"."Release Status"::"Released to Ship" then begin
                        ReleaseServiceDoc.PerformManualRelease("Service Header");
                        Commit();
                    end;
                end;
            end;
        }

    }

    trigger OnPostReport()
    begin
        Message('Processed Successfully');
    end;

}
