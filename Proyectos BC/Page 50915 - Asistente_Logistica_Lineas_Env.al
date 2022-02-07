page 50915 "Asistente Logistica Lineas Env"
{
    PageType = ListPart;
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = false;
    DelayedInsert = true;
    SourceTable = "RENT - Whse. Shipment Line";
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
                field("Cantidad de almacén para enviar"; Rec."Qty. to Ship")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Fecha de inicio del contrato"; Rec."Rental Contract Starting Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Fecha de Envío"; Rec."Shipment DateTime")
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
                    NotBlank = true;

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
                                    Rec."Serial No." := '';
                                    Rec."Responsible Name" := '';
                                    Rec."Responsible CIF/NIF" := '';
                                    Rec."Responsible Plate No." := '';
                                    Rec."Ship-to Contact" := '';
                                    Rec."Ship-to Contact Phone No." := '';
                                    Rec."Ship-to Contact Email" := '';
                                    Rec.Modify(true);
                                end;
                        end;
                    end;
                }
                field("Número de Serie"; Rec."Serial No.")
                {
                    ApplicationArea = Suite;
                    Editable = false;

                    trigger OnAssistEdit()
                    var
                        ParkSituationQueryPage: page "RENT - Park Situation Query";
                        RentSetup: Record "RENT - Setup";
                    begin
                        if Rec."Transport Responsible" = Rec."Transport Responsible"::Company then
                            exit;
                        RentSetup.get;
                        RentSetup.testfield("Available Bin Code");

                        if Rec."Confirmed Item No." <> '' THEN
                            ParkSituationQueryPage.SetSearchParams(Rec."Location Code", RentSetup."Available Bin Code", Rec."Confirmed Item No.")
                        else
                            ParkSituationQueryPage.SetSearchParams(Rec."Location Code", RentSetup."Available Bin Code", Rec."Original Item No.");

                        ParkSituationQueryPage.LookupMode(true);
                        if ParkSituationQueryPage.RunModal() = action::LookupOk then begin
                            Rec.Validate("Confirmed Item No.", ParkSituationQueryPage.GetSelectedItemNo());
                            Rec.Validate("Serial No.", ParkSituationQueryPage.GetSelectedSerialNo());
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord;
                    end;
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
                field("Envío-a Email Contacto"; Rec."Ship-to Contact Email")
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
        Responsable: Enum "RENT - Transport Responsible";
        AsistCode: Codeunit "Asistente Logistica CodeUnit";

    procedure SetMachineLinesEnv(var importSalesLine: Record "Sales Line" temporary)
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

                AsistCode.CreateWhseShptLineForSalesOrderLine(importSalesLine, Rec, Contador);

            until importSalesLine.Next() = 0;
        Rec.Reset();
        Rec.FindFirst();
    end;

    procedure CheckInsert()
    begin
        if AsistCode.CheckCamposEnv(Rec) then begin
            Rec.Modify();
            AsistCode.CrearLineaEnv(Rec);
        end;
    end;

}