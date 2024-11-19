page 52100 "WEH Assemble to order Link"
{
    ApplicationArea = All;
    Caption = 'Assemble to order Link';
    PageType = List;
    SourceTable = "Assemble-to-order Link";
    UsageCategory = Administration;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Assembled Quantity"; Rec."Assembled Quantity")
                {
                    ToolTip = 'Specifies the value of the Assembled Quantity field.', Comment = '%';
                }
                field("Assembly Document No."; Rec."Assembly Document No.")
                {
                    ToolTip = 'Specifies the value of the Assembly Document No. field.', Comment = '%';
                }
                field("Assembly Document Type"; Rec."Assembly Document Type")
                {
                    ToolTip = 'Specifies the value of the Assembly Document Type field.', Comment = '%';
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                    ToolTip = 'Specifies the value of the Document Line No. field.', Comment = '%';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.', Comment = '%';
                }
                field("Job No."; Rec."Job No.")
                {
                    ToolTip = 'Specifies the value of the Project No. field.', Comment = '%';
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ToolTip = 'Specifies the value of the Project Task No. field.', Comment = '%';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                }
                field(Type; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                }
            }
        }
    }
}
