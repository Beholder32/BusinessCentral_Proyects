/// <summary>
/// Report DOCS - Contrato Alquiler HUNE (ID 50905).
/// </summary>
report 50905 "DOCS - Contrato Alquiler HUNE"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'DOCS- Sales - Rent Contract';
    DefaultLayout = RDLC;
    RDLCLayout = 'layout/ContratoAlquilerHUNE.rdl';
    dataset
    {
        dataitem(Header; "Sales Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Posted Rent Contract';

            // ----- ETIQUETAS DEL CONTRATO -----
            column(MensajePieLbl; MensajePieLbl) { }
            column(TitleLbl; TitleLbl) { }
            column(TenantDataLbl; TenantDataLbl) { }
            column(BusinessNameLbl; BusinessNameLbl) { }
            column(TelephoneLbl; TelephoneLbl) { }
            column(CIF_NIFLbl; CIF_NIFLbl) { }
            column(WorkplaceLbl; WorkplaceLbl) { }
            column(ContactDetailsLbl; ContactDetailsLbl) { }
            column(CustomerNoLbl; CustomerNoLbl) { }
            column(ContractNoLbl; ContractNoLbl) { }
            column(CodigoObraLbl; CodigoObraLbl) { }
            column(OrderDateLbl; OrderDateLbl) { }
            column(PaymentTermsLbl; PaymentTermsLbl) { }
            column(PaymentMethodLbl; PaymentMethodLbl) { }
            column(ArticlLble; ArticleLbl) { }
            column(MachineLbl; MachineLbl) { }
            column(DescriptionLbl; DescriptionLbl) { }
            column(Starting_End_DateLbl; Starting_End_DateLbl) { }
            column(NetPriceLbl; NetPriceLbl) { }
            column(NotIncludeLbl; NotIncludeLbl) { }
            column(SignLbl; SignLbl) { }

            //---- DATOS EMPRESA ----
            column(NombreEmpresa; InfoEmpresa.Name) { }
            column(DirectEmpresa; InfoEmpresa.Address + ' ' + InfoEmpresa."Address 2") { }
            column(PoblacionEmpresa; InfoEmpresa."Post Code" + ' ' + InfoEmpresa.City) { }
            column(CodPais; InfoEmpresa."Country/Region Code" + ' ' + InfoEmpresa."VAT Registration No.") { }
            column(TelefonoEmpresa; InfoEmpresa."Phone No.") { }
            column(ImagenRedes; InfoEmpresa."Vertical Documents Text") { }
            column(ImagenPie2; InfoEmpresa."Picture Footer 2") { }

            //---- DATOS EMPRESA EMISORA ----
            column(NombreCR; CentroEmisor.Name) { }
            column(DireccionCR; CentroEmisor.Address + ' ' + CentroEmisor."Address 2") { }
            column(PoblacionCR; CentroEmisor."Post Code" + ' ' + CentroEmisor.City) { }
            column(CiudadCR; CentroEmisor."Country/Region Code") { }
            column(TelfCR; CentroEmisor."Phone No.") { }

            //---- GENERAL ----
            column(No_; "No.") { }
            column(NumeroCliente; "Sell-to Customer No.") { }
            column(NombreCliente; "Sell-to Customer Name") { }
            column(ResultadoEjecucion; "Sell-to Customer Name 2") { }
            column(ArrayDeDatosCLiente1; ArrayDeDatosCLiente[1]) { }
            column(ArrayDeDatosCLiente2; ArrayDeDatosCLiente[2]) { }
            column(ArrayDeDatosCLiente3; ArrayDeDatosCLiente[3]) { }
            column(ArrayDeDatosCLiente4; ArrayDeDatosCLiente[4]) { }
            column(ArrayDeDatosCLiente5; ArrayDeDatosCLiente[5]) { }
            column(Telefono; TablaCliente."Phone No.") { }
            column(TelefonoMovil; SellToContact."Mobile Phone No.") { }
            column(Email; "Sell-to E-Mail") { }
            column(Contacto; "Sell-to Contact") { }
            column(NumeroVersionesArch; "No. of Archived Versions") { }
            column(FechaEmision; Format("Document Date", 0, 1)) { }
            column(FechaRegistro; Format("Posting Date", 0, 1)) { }
            column(FechaPedido; Format("Order Date", 0, 1)) { }
            column(FechaVencimiento; Format("Due Date", 0, 1)) { }
            column(CentroResponsabilidad; "Responsibility Center") { }
            column(FechaInicio; Format("Starting Date", 0, 1)) { }
            column(FechaFinalizacion; Format("Ending Date", 0, 1)) { }
            column(CodVendedor; "Salesperson Code") { }
            column(IdUsuarioAsignado; "Assigned User ID") { }
            column(CondicionesComerciales; "Commercial Conditions") { }
            column(NumDocumentoExterno; "External Document No.") { }
            column(SuReferencia; "Your Reference") { }
            column(CodigoObra; "Work Code") { }
            column(WorkName; "Work Name") { }
            column(Negocio; "Business") { }
            column(DivisionNo; "Division No.") { }
            column(Estado; "Status") { }

            // ---- SOURCE CHANNEL ----
            column(DocCanalOrigen; "Doc. Source Channel") { }
            column(FuenteNo; "Quote No.") { }
            column(RevisionFuente; "Doc. Source Review No.") { }
            column(SolicitudWeb; "Web Request No.") { }

            // ---- ENVIO Y FACTURACION ----
            column(ArrayDeDatosEnvio1; ArrayDeDatosEnvio[1]) { }
            column(ArrayDeDatosEnvio2; ArrayDeDatosEnvio[2]) { }
            column(ArrayDeDatosEnvio3; ArrayDeDatosEnvio[3]) { }
            column(ArrayDeDatosEnvio4; ArrayDeDatosEnvio[4]) { }
            column(ArrayDeDatosEnvio5; ArrayDeDatosEnvio[5]) { }
            column(ArrayDeDatosEnvio6; ArrayDeDatosEnvio[6]) { }
            column(ArrayDeDatosEnvio7; ArrayDeDatosEnvio[7]) { }
            column(ArrayDeDatosEnvio8; ArrayDeDatosEnvio[8]) { }

            //column(FacturacionA; BillToOptions) { }
            column(CodAlmacen; "Location Code") { }
            column(FechaEnvio; Format("Shipment Date", 0, 1)) { }
            column(AvisoEnvio; "Shipping Advice") { }
            column(TiempoManipulacionAlmacenSalida; "Outbound Whse. Handling Time") { }
            column(TiempoEnvio; "Shipping Time") { }
            column(EnvioRetrasado; "Late Order Shipping") { }
            column(FactAutomatica; "Invoice") { }
            // ---- Metodo de envio ----
            column(MetodoCodigo; "Shipment Method Code") { }
            column(MetodoAgente; "Shipping Agent Code") { }
            column(ServicioAgentes; "Shipping Agent Service Code") { }
            column(SeguimientoBulto; "Package Tracking No.") { }
            // _____ LINES _____
            dataitem(Lines; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = Header;
                column(Amount; Amount) { }
                column(Description; Description) { }
                column(Tipo; "Type") { }
                column(CodTrabajoDiarioMaquina; "Machine Daily Work Code") { }
                column(NumeroMaquina; "Machine No.") { }
                column(NoMaquina; "Machine No.") { }
                column(No; "No.") { }
                column(DescripcionMaquina; "Description") { }
                column(FechaInicioMaquina; Format("Starting Date", 0, 1)) { }
                column(FechaFinalizacionMaquina; Format("Ending Date", 0, 1)) { }
                column(FechaFinalizacionPrevista; Format("Expected Ending Date", 0, 1)) { }
                column(CantidadMaquina; "Quantity") { }
                column(CantidadEnviada; "Quantity Shipped") { }
                column(DiasDescontados; "Discounted Days Quantity") { }
                column(PrecioNeto; NetPriceText()) { }
                column(PesoNetoRegimen; PrecioNeto) { }
                column(CodigoTarifa; "Rate Code") { }
                column(NombreTarifa; "Rate Name") { }
                column(Bloqueado; Blocked) { }
                column(CalendarioAlquileres; "Working Days Calendar") { }
                column(IncluyeFestivos; "Charge/Service Exemption") { }
                column(TipoBonificacionTransporte; "Transport Bonification Type") { }
                column(BonificacionTransporte; "Transport Bonification") { }
                column(IVA; "VAT %") { }

                // Gatillo para discriminar lineas e imprimir solo una de cada tipo y que no tengan Type vacío
                trigger OnAfterGetRecord()
                var
                begin
                    //if lines.type = lines.Type::" " then
                    //CurrReport.Skip();
                    if Blocked = true then
                        CurrReport.Skip();

                    IF Lines."Regime Net Price" = 0 then
                        PrecioNeto := NetPriceText()
                    else
                        PrecioNeto := RegimeNetPriceText();

                    if RegimeNetPriceText() = '' then
                        if NetPriceText() = '' then
                            CurrReport.Skip();

                    if Lines."Description" = 'Alquiler' then
                        CurrReport.Skip();

                    if Lines."Description" = 'Periodos de Alquiler' then
                        CurrReport.Skip();

                    if Lines."Description" = 'Periodos del Cargo Seguro' then
                        CurrReport.Skip();
                    // Cada vez que aparezca "Seguro y alguna cosa" sustituir por la palabra seguro y que aparezca el precio del primer período
                    if Lines."Description".Contains('Seguro') then begin
                        Lines."Description" := 'Seguro';
                        Lines."Starting Date" := 0D;
                        Lines."Ending Date" := 0D;
                    end;

                    if Lines."Description" = ' ' then
                        CurrReport.Skip();

                    IF Lines."Description" = DescripcionTemp then
                        CurrReport.Skip();
                    DescripcionTemp := Lines."Description";

                end;
            }

            // ---- Envio contrato de Alquiler (Lines) ----
            column(NoAlbaranEntrega; EnvioContratoAlquiler."Entry No.") { }
            column(EstadoEnvio; EnvioContratoAlquiler."Status") { }
            column(NoProductoOriginal; EnvioContratoAlquiler."Original Item No.") { }
            column(NoProductoConfirmado; EnvioContratoAlquiler."Confirmed Item No.") { }
            column(NumeroSerie; EnvioContratoAlquiler."Serial No.") { }
            column(Descripcion; EnvioContratoAlquiler."Description") { }
            column(FechaHoraEnvio; Format(EnvioContratoAlquiler."Shipment DateTime", 0, 1)) { }
            column(FechaHoraVencimientoEnvio; Format(EnvioContratoAlquiler."Due DateTime", 0, 1)) { }
            column(ResponsableTransporte; EnvioContratoAlquiler."Transport Responsible") { }
            column(NombreResponsable; EnvioContratoAlquiler."Responsible Name") { }
            column(CIFNIFResponsable; TablaCliente."VAT Registration No.") { }
            column(MatriculaResponsable; EnvioContratoAlquiler."Responsible Plate No.") { }
            column(EnvioContacto; EnvioContratoAlquiler."Ship-to Contact") { }
            column(EnvioNTelefonoCliente; EnvioContratoAlquiler."Ship-to Contact Phone No.") { }
            column(ShipToContactEmail; EnvioContratoAlquiler."Ship-to Contact Email") { }
            column(Comentario; EnvioContratoAlquiler."Comment") { }

            // ---- Recibo contrato de Alquiler (Lines) ----
            column(NoAlbaran; ReciboContratoAlquiler."Entry No.") { }
            column(EstadoReciboAlbaran; ReciboContratoAlquiler."Status") { }
            column(BoProductoOriginal; ReciboContratoAlquiler."Original Item No.") { }
            column(NoProductoConfirmadoRecibo; ReciboContratoAlquiler."Confirmed Item No.") { }
            column(SerialNo; ReciboContratoAlquiler."Serial No.") { }
            column(DescripcionReciboAlbaran; ReciboContratoAlquiler."Description") { }
            column(FechaHoraRecogida; ReciboContratoAlquiler."Shipment DateTime") { }
            column(FechaHoraVencimiento; ReciboContratoAlquiler."Due DateTime") { }
            column(ResponsableTransporteRecibo; ReciboContratoAlquiler."Transport Responsible") { }
            column(NombreResponsableRecibo; ReciboContratoAlquiler."Responsible Name") { }
            //column(CIFNIFResponsableRecibo; ReciboContratoAlquiler.) { }
            column(MatriculaResponsableRecibo; ReciboContratoAlquiler."Responsible Plate No.") { }
            column(EnvioContactoRecibo; ReciboContratoAlquiler."Ship-to Contact") { }
            column(EnvioNTelefonoClienteRecibo; ReciboContratoAlquiler."Ship-to Contact Phone No.") { }
            column(ComentarioRecibo; "Comment") { }

            // ---- DETALLES DE LA FACTURA ----
            column(CodDivisa; "Currency Code") { }
            column(PreciosIVAIncluido; "Prices Including VAT") { }
            column(GrupoContableIVA; "VAT Bus. Posting Group") { }
            column(CodTerminosPago; "Payment Terms Code") { }
            column(CodFormaPago; "Payment Method Code") { }
            column(OpTriangular; "EU 3-Party Trade") { }
            column(ServicioPago; "Posting No. Series") { }
            column(BaseCodigo; "Location Code") { }
            column(LineaCodigo; "Shortcut Dimension 2 Code") { }
            column(DtoPP; "Payment Discount %") { }
            column(FechaDtoPP; "Pmt. Discount Date") { }
            column(IDOrdenDomiciliacion; "Direct Debit Mandate ID") { }
            column(DescripcionOperacion; "Operation Description") { }
            column(CodEsquemaEspecial; "Special Scheme Code") { }
            column(TipoDeFactura; "Invoice Type") { }
            column(TipoID; "ID Type") { }
            column(NombreEmpresaCorrecto; "Succeeded Company Name") { }
            column(CIFCorrecto; "Succeeded VAT Registration No.") { }

            // ---- PAGO ----
            column(PagoCodigo; "Pay-at Code") { }//Desplegable
            column(CodBancoCliente; "Cust. Bank Acc. Code") { }

            // ---- COMERCIO EXTERIOR ----
            column(EspecifTransaccion; "Transaction Specification") { }
            column(NaturalezaTransaccion; "Transaction Type") { }
            column(ModoTransporte; "Transport Method") { }
            column(PuertoAeropCarga; "Exit Point") { }
            column(AreaComercio; "Area") { }

            // ---- PREPAGO ----
            column(PercPrepago; "Prepayment %") { }
            column(CompresionPrepago; "Compress Prepayment") { }
            column(CodTerminosPrepago; "Prepmt. Payment Terms Code") { }
            column(FechaVencimientoPrepago; "Prepayment Due Date") { }
            column(PercDescuentoPrepago; "Prepmt. Payment Discount %") { }
            column(FechaDescPrepago; "Prepmt. Pmt. Discount Date") { }
            column(NombreImpuesto; NombreImpuestoLbl) { }
            //Este trigger funciona usando la funcion creada en Codeunit que se encarga de rellenar un array con datos
            trigger OnAfterGetRecord()
            var
            begin
                GeneralFunction.DatosCliente(ArrayDeDatosCliente, Header);
                GeneralFunction.DatosEnvio(ArrayDeDatosEnvio, Header);

                CentroEmisor.Get("Responsibility Center");
                TablaCliente.Get("Sell-to Customer No.");

                "Language Code" := Language.GetUserLanguageCode;
                CurrReport.Language := Language.GetLanguageIdOrDefault("Language Code");

                //Para checkear cuando un report está siendo impreso
                if not IsReportInPreviewMode then
                    CODEUNIT.Run(CODEUNIT::"Sales-Printed", Header);

                //CodPostalTabla.Get("Ship-to Post Code", "Ship-to County");
                CodPostalTabla.SetFilter(Code, "Ship-to Post Code");
                CodPostalTabla.FindFirst();
                CodProv := CodPostalTabla."County Code";

                IF CodProv = '35' then
                    NombreImpuestoLbl := 'IGIC'
                else
                    IF CodProv = '38' then
                        NombreImpuestoLbl := 'IGIC'
                    else
                        NombreImpuestoLbl := 'IVA'
            end;
        }
    }

    trigger OnPreReport()
    begin
        InfoEmpresa.Get();
    end;

    var
        // ------ VARIABLES DE IDIOMA ------
        MensajePieLbl: Label 'El presente contrato se regirá por las condiciones generales que figuran al dorso, las cuales han sido leidas y aceptadas expresamente por el cliente. El seguro de la maquinaria alquilada, será por día Natural.';
        CodProv: Code[20];
        CodPostal: Text;
        CodPostalTabla: Record "Post Code";
        NombreImpuestoLbl: Text;
        CodigoObraLbl: Label 'Codigo Obra';
        TitleLbl: Label 'RENTAL CONTRACT';
        TenantDataLbl: Label 'Tenant Data';
        BusinessNameLbl: Label 'Business Name';
        TelephoneLbl: Label 'Phone No.';
        CIF_NIFLbl: Label 'CIF/NIF';
        WorkplaceLbl: Label 'Workplace';
        ContactDetailsLbl: Label 'Contact Details';
        CustomerNoLbl: Label 'Customer No.';
        ContractNoLbl: Label 'Contract No.';
        ContractDateLbl: Label 'Contract Date';
        OrderDateLbl: Label 'Order Date';
        PaymentTermsLbl: Label 'Payment Terms';
        PaymentMethodLbl: Label 'Payment Method';
        ArticleLbl: Label 'Article';
        MachineLbl: Label 'Machine';
        DescriptionLbl: Label 'Description';
        Starting_End_DateLbl: Label 'Starting Date/End';
        NetPriceLbl: Label 'NetPrice';
        NotIncludeLbl: Label '(Not Include)';
        SignLbl: Label 'Name, ID, Sign';

        // ------ FIN VARIABLES IDIOMA -------

        PrecioNeto: Text;
        Language: Codeunit Language;
        SellToContact: Record Contact;
        TablaCliente: Record Customer;
        EnvioContratoAlquiler: Record "RENT - Whse. Shipment Line";
        ReciboContratoAlquiler: Record "RENT - Whse. Shipment Line";
        GeneralFunction: Codeunit "DOCS - General Function";
        ArrayDeDatosCLiente: array[5] of Text[100];
        ArrayDeDatosEnvio: array[8] of Text;
        DescripcionTemp: Text[100];
        InfoEmpresa: Record "Company Information";
        CentroEmisor: Record "Responsibility Center";
        PorcentageIVA: Text[20];
        NombreImpuesto: Text[20];

    //Para saber si está impreso
    local procedure IsReportInPreviewMode(): Boolean
    var
        MailManagement: Codeunit "Mail Management";
    begin
        exit(CurrReport.Preview or MailManagement.IsHandlingGetEmailBody);
    end;
}
