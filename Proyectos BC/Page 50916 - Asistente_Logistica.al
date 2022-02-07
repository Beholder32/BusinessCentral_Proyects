page 50916 "Logistic Assistant"
{
    Caption = 'Asistente Logístico';
    DataCaptionFields = "No.";
    PageType = NavigatePage;
    SourceTable = "Sales Line";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(StandardBanner)
            {
                Editable = false;
                Visible = TopBannerVisible and (CurrentStep < 3);

                field(MediaRepositoryStandard; MediaResourcesStandard."Media Reference")
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                }
            }
            group(FinishedBanner)
            {
                Editable = false;
                Visible = TopBannerVisible and (CurrentStep = 3);
                field(MediaResourcesDone; MediaResourcesDone."Media Reference")
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                }
            }
            group(Step1)
            {
                Visible = CurrentStep = 1;
                group("Ventana Bienvenida")
                {
                    Caption = 'Creación automática de líneas para Envío y Recibo de Contratos del alquiler';
                    field("Numero de Contrato"; gSalesHeader."No.")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("Nº Cliente"; gSalesHeader."Sell-to Customer No.")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("Nombre Cliente"; gSalesHeader."Sell-to Customer Name")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("Centro de Responsabilidad"; gSalesHeader."Responsibility Center")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                }
                group("Seleccion de tipo de línea")
                {
                    Caption = 'Tipo de procedimiento';
                    field(Enviar; Envio)
                    {
                        ApplicationArea = All;
                        Caption = 'Envío';
                        trigger OnValidate()
                        begin
                            ActivarEnvio();
                        end;
                    }
                    field(Recibir; Recibo)
                    {
                        ApplicationArea = All;
                        Caption = 'Recibo';
                        trigger OnValidate()
                        begin
                            ActivarRecibo();
                        end;
                    }
                }
            }
            group(Step2)
            {
                Visible = CurrentStep = 2;
                group("Opcion A")
                {
                    Visible = Envio;
                    Caption = 'Líneas de Contrato';
                    Editable = false;

                    repeater(Envio)
                    {
                        field(Env_No; Rec."No.")
                        {
                            ApplicationArea = All;
                        }
                        field(Env_MachineNo; Rec."Machine No.")
                        {
                            ApplicationArea = All;
                        }
                        field(Env_Description; Rec.Description)
                        {
                            ApplicationArea = All;
                        }
                        field(Env_Quantity; Rec.Quantity)
                        {
                            ApplicationArea = All;
                        }
                        field(Env_fechaInicio; Rec."Starting Date")
                        {
                            ApplicationArea = All;
                        }
                        field(Env_LocationCode; Rec."Location Code")
                        {
                            ApplicationArea = All;
                        }
                        field(Env_BinCode; Rec."Bin Code")
                        {
                            ApplicationArea = All;
                        }
                    }
                }
                group("Opcion B")
                {
                    Visible = Recibo;
                    Caption = 'Líneas de Contrato (Solo aparecerán aquellas que tengan relleno el campo de Fecha de Finalización )';
                    Editable = false;
                    repeater(Recepcion)
                    {
                        field(Rec_No; Rec."No.")
                        {
                            ToolTip = 'Specifies the value of the No. field.';
                            ApplicationArea = All;
                        }
                        field(Rec_MachineNo; Rec."Machine No.")
                        {
                            ToolTip = 'Specifies the value of the Machine No. field.';
                            ApplicationArea = All;
                        }
                        field(Rec_Description; Rec.Description)
                        {
                            ToolTip = 'Specifies the value of the Description field.';
                            ApplicationArea = All;
                        }
                        field(Rec_Quantity; Rec.Quantity)
                        {
                            ToolTip = 'Specifies the value of the Quantity field.';
                            ApplicationArea = All;
                        }
                        field(Rec_LocationCode; Rec."Location Code")
                        {
                            ToolTip = 'Specifies the value of the Location Code field.';
                            ApplicationArea = All;
                        }
                        field(Rec_BinCode; Rec."Bin Code")
                        {
                            ToolTip = 'Specifies the value of the Bin Code field.';
                            ApplicationArea = All;
                        }
                    }
                }
            }
            group(Step3)
            {
                Visible = CurrentStep = 3;
                group("Opcion A Check")
                {
                    Visible = Envio;
                    Caption = 'Líneas de Contrato';
                    group("Activos seleccionados para línea de envío")
                    {
                        Visible = Envio;
                        part(SubformLanzadoEnv; "Asistente Logistica Lineas Env")
                        {
                            ApplicationArea = All;
                        }
                    }
                }
                group("Opcion B Check")
                {
                    Visible = Recibo;
                    Caption = 'Líneas de Contrato';
                    group("Activos seleccionados para línea de recibo")
                    {
                        Visible = Recibo;
                        part(SubformLanzadoRec; "Asistente Logistica Lineas Rec")
                        {
                            ApplicationArea = All;
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionBack)
            {
                ApplicationArea = All;
                Caption = 'Back';
                InFooterBar = true;
                Enabled = ActionBackAllowed;
                Image = PreviousRecord;
                trigger OnAction()
                begin
                    if CurrentStep = 2 then
                        rec.Reset();
                    TakeStep(-1);
                end;
            }
            action(ActionNext)
            {
                ApplicationArea = All;
                Caption = 'Next';
                InFooterBar = true;
                Enabled = ActionNextAllowed;
                Image = NextRecord;
                trigger OnAction()
                begin
                    CurrPage.Update(false);
                    TakeStep(1);
                end;
            }
            action(ActionFinish)
            {
                ApplicationArea = All;
                Caption = 'Finish';
                InFooterBar = true;
                Enabled = ActionFinishAllowed;
                Image = Approve;
                trigger OnAction()
                begin
                    if Envio then
                        CurrPage.SubformLanzadoEnv.Page.CheckInsert();
                    if Recibo then
                        CurrPage.SubformLanzadoRec.Page.CheckInsert();
                    CurrPage.Close();
                end;
            }
        }
    }

    var
        MediaRepositoryDone: Record "Media Repository";

        //------ Tabla para sacar botones ------
        MediaRepositoryStandard: Record "Media Repository";
        MediaResourcesDone: Record "Media Resources";
        MediaResourcesStandard: Record "Media Resources";

        //----- VARIABLES PARA ALOJAR TABLAS ------
        gSalesHeader: Record "Sales Header";
        ActionBackAllowed: Boolean;
        ActionFinishAllowed: Boolean;
        ActionNextAllowed: Boolean;
        Envio: Boolean;
        Recibo: Boolean;
        TopBannerVisible: Boolean;
        CurrentStep: Integer;

    // ----- PROCEDIMIENTOS -----

    // EN DESUSO ------>
    procedure SetGlobalSalesHeader(pSalesHeader: Record "Sales Header")
    var
        SalesLines: Record "Sales Line";
    begin
        gSalesHeader.Reset();
        gSalesHeader.SetRange("Document Type", pSalesHeader."Document Type");
        gSalesHeader.SetRange("No.", pSalesHeader."No.");
        gSalesHeader.FindFirst();

        SalesLines.Reset();
        SalesLines.SetRange("Document Type", gSalesHeader."Document Type");
        SalesLines.SetRange("Document No.", gSalesHeader."No.");
        SalesLines.SetRange(Machinery, true);
        if SalesLines.FindSet() then begin
            Rec.Reset;
            Rec.DeleteAll();
            repeat
                Rec.init;
                Rec.TransferFields(SalesLines);
                Rec.insert;
            until saleslines.next = 0;
        end;
    end;
    // <------ HASTA AQUÍ
    local procedure DarVisibilidad()
    begin
        case CurrentStep of
            2:
                begin
                    if Envio then begin
                        Rec.SetRange("Warehouse Qty. Received", 0);
                        Rec.SetRange("Warehouse Qty. to Ship", 0);
                        //Rec.SetRange("Warehouse Qty. Shipped", 0);
                    end else begin
                        Rec.SetRange("Warehouse Qty. Received", 0);
                        Rec.SetRange("Warehouse Qty. Shipped", 1);
                        Rec.SetRange("Warehouse Qty. to Receive", 0);
                        Rec.SetFilter("Ending Date", '<>%1', 0D);
                    end;
                end;
            3:
                begin
                    if Envio then begin
                        CurrPage.SetSelectionFilter(Rec);
                        CurrPage.SubformLanzadoEnv.Page.SetMachineLinesEnv(Rec);
                        CurrPage.SubformLanzadoEnv.Page.Update(false);
                        Rec.Reset;
                    end else begin
                        CurrPage.SetSelectionFilter(Rec);
                        CurrPage.SubformLanzadoRec.Page.SetMachineLinesRec(Rec);
                        CurrPage.SubformLanzadoRec.Page.Update(false);
                        Rec.Reset;
                    end;
                end;
        end;
    end;

    local procedure ActivarEnvio()
    begin
        if Envio then
            Recibo := false
        else
            Recibo := true;
    end;

    local procedure ActivarRecibo()
    begin
        if Recibo then
            Envio := false
        else
            Envio := true;
    end;

    local procedure SetControls()
    // Aqui es donde iría en control de deshabilitar el botón si no existen registros
    begin
        ActionBackAllowed := CurrentStep > 1;
        ActionNextAllowed := CurrentStep < 3;
        ActionFinishAllowed := CurrentStep = 3;
        if Rec.Count() = 0 then
            if CurrentStep = 2 then
                ActionNextAllowed := false;
    end;

    local procedure TakeStep(Step: Integer)
    begin
        CurrentStep += Step;
        DarVisibilidad();
        SetControls;
    end;

    local procedure LoadTopBanners()
    begin
        if (MediaRepositoryStandard.Get('AssistedSetup-NoText-400px.png', Format(CurrentClientType())) and MediaRepositoryDone.Get('AssistedSetupDone-NoText-400px.png', Format(CurrentClientType())))
        then
            if MediaResourcesStandard.Get(MediaRepositoryStandard."Media Resources Ref") and MediaResourcesDone.Get(MediaRepositoryDone."Media Resources Ref")
            then
                TopBannerVisible := MediaResourcesDone."Media Reference".HasValue();
    end;

    // ----- DISPARADORES ------
    trigger OnInit()
    begin
        LoadTopBanners;
    end;

    trigger OnOpenPage()
    begin
        CurrentStep := 1;
        SetControls;

        Envio := true;
        Recibo := false;

        gSalesHeader.SetRange("No.", Rec."Document No.");
        gSalesHeader.FindFirst();
    end;
}