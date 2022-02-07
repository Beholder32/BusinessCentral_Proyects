page 50914 "Asistente Logistica Lineas Rec"
{
    PageType = ListPart;
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = false;
    DelayedInsert = true;
    SourceTable = "RENT - Whse. Receipt Line";
    Caption = 'Campos necesarios';
    SourceTableTemporary = true; // Importante no borrar

    layout
    {
        area(Content)
        {
            repeater("Listado de máquinas disponibles")
            {
                field("Num de Resgistro"; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Numero de Maquina"; Rec."Original Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Desc. de Maquina"; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Cantidad de almacén para enviar"; Rec."Qty. to Receive")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Fecha de Envío"; Rec."Receipt DateTime")
                {
                    ApplicationArea = All;
                    Editable = true;
                    NotBlank = true;
                }
                field("Fecha de Vencimiento Env"; Rec."Due DateTime")
                {
                    ApplicationArea = All;
                    Editable = true;
                    NotBlank = true;
                }
                field("Responsable del transporte Env"; Responsable)
                {
                    ApplicationArea = All;
                    ValuesAllowed = 1, 2;

                    trigger OnValidate()
                    begin
                        Rec.TestField(status, Rec.Status::" ");

                        case Responsable of
                            Responsable::Customer:
                                begin
                                    Rec.TestField(status, Rec.Status::" ");
                                    Rec.VALIDATE("Transport Responsible", Responsable::Customer);
                                    Rec.Modify(true);
                                end;
                            Responsable::Company:
                                begin
                                    Rec.TestField(status, Rec.Status::" ");
                                    Rec.VALIDATE("Transport Responsible", Responsable::Company);
                                    Rec."Responsible Name" := '';
                                    Rec."Responsible CIF/NIF" := '';
                                    Rec."Responsible Plate No." := '';
                                    Rec."Ship-to Contact" := '';
                                    Rec."Ship-to Contact Phone No." := '';
                                    Rec.Modify(true);
                                end;
                        end;
                    end;
                }
                field("Número de Serie"; Rec."Serial No.")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                }
                field("Responsible Name"; Rec."Responsible Name")
                {
                    ApplicationArea = all;
                    Editable = (Rec."Transport Responsible" = Rec."Transport Responsible"::Customer);
                }
                field("CIF Responsable Env"; Rec."Responsible CIF/NIF")
                {
                    ApplicationArea = All;
                    Editable = (Rec."Transport Responsible" = Rec."Transport Responsible"::Customer);
                }
                field("Nº Matrícula Env"; Rec."Responsible Plate No.")
                {
                    ApplicationArea = All;
                    Editable = (Rec."Transport Responsible" = Rec."Transport Responsible"::Customer);
                }
                field("Envío-a Contacto"; Rec."Ship-to Contact")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Envío-a Teléfono Contacto"; Rec."Ship-to Contact Phone No.")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Comentarios"; Rec.Comment)
                {
                    ApplicationArea = All;
                    Editable = true;
                }
            }
        }
    }

    var
        AsistCode: Codeunit "Asistente Logistica CodeUnit";
        Responsable: Enum "RENT - Transport Responsible";

    procedure CheckInsert()
    begin
        if AsistCode.CheckCamposRec(Rec) then begin
            Rec.Modify();
            AsistCode.CrearLineaRec(Rec);
        end;
    end;

    procedure SetMachineLinesRec(var importSalesLine: Record "Sales Line" temporary)
    var
        Contador: Integer;
    begin
        Rec.Reset;
        Rec.DeleteAll();

        IF importSalesLine.IsEmpty then
            exit;

        if importSalesLine.FindSet() then
            repeat

                Contador += 1;

                importSalesLine."Warehouse Qty. to Receive" := importSalesLine."Warehouse Qty. Shipped" - importSalesLine."Warehouse Qty. Received";
                importSalesLine.Modify();

                AsistCode.CreateWhseRcptLineForSalesOrderLine(importSalesLine, Rec, Contador);

            until importSalesLine.Next() = 0;
        Rec.Reset();
        Rec.FindFirst();
    end;
}