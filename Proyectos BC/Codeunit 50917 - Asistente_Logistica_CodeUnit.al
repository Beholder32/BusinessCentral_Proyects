codeunit 50917 "Asistente Logistica CodeUnit"
{
    trigger OnRun()
    begin

    end;

    // -------- CREACION DE LAS LINEAS EN EL ASISTENTE
    procedure CreateWhseShptLineForSalesOrderLine(SalesOrderLine: record "Sales Line"; var WhseShptLine: record "RENT - Whse. Shipment Line" Temporary; pEntryNo: Integer)
    var
        SalesOrder: Record "Sales Header";
        Currency: record Currency;

        Item: record Item;
        Location: Record location;
        IsHandled: Boolean;
        WhseShptMgt: Codeunit "RENT - Whse. Shipment Mgt.";
        RentalSetup: Record "RENT - Setup";
    begin
        RentalSetup.Get;
        RentalSetup.TestField("Contract Location");

        if WhseShptMgt.GetAliveWhseShipmentLine(WhseShptLine, SalesOrderLine) then
            exit;

        SalesOrderLine.TestField(Type, SalesOrderLine.type::Item);
        SalesOrderLine.TestField(Machinery, true);
        SalesOrderLine.TestField("Location Code");
        SalesOrderLine.TestField("Starting Date");
        Item.Get(SalesOrderLine."No.");

        WhseShptLine.init;
        WhseShptLine."Entry No." := pEntryNo;

        WhseShptLine."Original Item No." := SalesOrderLine."No.";
        WhseShptLine."Rental Contract Starting Date" := SalesOrderLine."Starting Date";
        WhseShptLine."Variant Code" := SalesOrderLine."Variant Code";
        WhseShptLine."Location Code" := SalesOrderLine."Location Code";
        WhseShptLine."Destination Location Code" := SalesOrderLine."Location Code";
        //this won´t always be contract location but is an aproximation
        WhseShptLine."Bin Code" := RentalSetup."Available Bin Code";
        WhseShptLine."Destination Bin Code" := RentalSetup."Contract Bin Code";
        WhseShptLine."Ship-to Contact Phone No." := WhseShptMgt.GetNumberPhone(SalesOrder."Ship-to Contact");

        Location.GET(WhseShptLine."Location Code");
        Location.TestField("Responsibility Center Code");
        WhseShptLine."Responsibility Center Code" := Location."Responsibility Center Code";
        WhseShptLine.Description := SalesOrderLine.Description;
        WhseShptLine."Description 2" := SalesOrderLine."Description 2";
        WhseShptLine.Quantity := SalesOrderLine.Quantity;
        WhseShptLine."Qty. (Base)" := SalesOrderLine."Quantity (Base)";
        WhseShptLine."Qty. Outstanding" := SalesOrderLine.Quantity;
        WhseShptLine."Qty. Outstanding (Base)" := SalesOrderLine."Quantity (Base)";
        WhseShptLine."Qty. per Unit of Measure" := SalesOrderLine."Qty. per Unit of Measure";
        WhseShptLine."Qty. Shipped" := 0;
        WhseShptLine."Qty. Shipped (Base)" := 0;
        WhseShptLine."Qty. to Ship" := SalesOrderLine.Quantity;
        WhseShptLine."Qty. to Ship (Base)" := SalesOrderLine."Quantity (Base)";
        WhseShptLine."Unit of Measure Code" := SalesOrderLine."Unit of Measure Code";

        WhseShptLine.SetSource(DATABASE::"Sales Line", SalesOrderLine."Document No.", SalesOrderLine."Line No.");
        WhseShptLine.Status := WhseShptLine.Status::" ";
        WhseShptLine."Transport Responsible" := WhseShptLine."Transport Responsible"::Company;

        SalesOrderLine.GetSalesHeader(SalesOrder, Currency);

        WhseShptLine."Ship-to Customer No." := SalesOrder."Sell-to Customer No.";
        WhseShptLine."Ship-to Address" := SalesOrder."Ship-to Address";
        WhseShptLine."Ship-to Address 2" := salesorder."Ship-to Address 2";
        WhseShptLine."Ship-to City" := salesorder."Ship-to City";
        WhseShptLine."Ship-to County" := salesorder."Ship-to County";

        SalesOrder.TestField("Ship-to Post Code");
        salesorder.TestField("Ship-to Country/Region Code");

        WhseShptLine."Ship-to Post Code" := salesorder."Ship-to Post Code";
        WhseShptLine."Ship-to Country/Region Code" := salesorder."Ship-to Country/Region Code";
        WhseShptLine."Ship-to Name" := salesorder."Ship-to Name";
        WhseShptLine."Ship-to Name 2" := salesorder."Ship-to Name 2";
        WhseShptLine."Parent Entry No." := WhseShptMgt.GetParentEntryNo(SalesOrderLine);
        WhseShptLine.Business := SalesOrder.Business;
        WhseShptLine."Rate Code" := SalesOrderLine."Rate Code";
        WhseShptLine."Ship-to Contact Phone No." := WhseShptMgt.GetNumberPhone(SalesOrder."Ship-to Contact");

        WhseShptLine."Rental Contract Ext.Doc.No." := SalesOrder."External Document No.";

        WhseShptLine.Insert();
    end;

    procedure CreateWhseRcptLineForSalesOrderLine(SalesOrderLine: record "Sales Line"; var WhseRcptLine: record "RENT - Whse. Receipt Line" Temporary; pEntryNo: Integer)
    var
        SalesOrder: Record "Sales Header";
        Currency: record Currency;
        WhseShptLine: record "RENT - Whse. Shipment Line";
        Item: record Item;
        Location: Record location;
        WhseRectMgt: Codeunit "RENT - Whse. Receipt Mgt.";
        RentalSetup: Record "RENT - Setup";
    begin
        if SalesOrderLine."Warehouse Qty. to Receive" = 0 then
            exit;

        WhseRcptLine.CheckSourceDocLineQty(); // Observar ejectos de este procedimiento
        if WhseRectMgt.GetAliveWhseReceiptLine(WhseRcptLine, SalesOrderLine) then
            exit;

        SalesOrderLine.TestField(Type, SalesOrderLine.type::Item);
        SalesOrderLine.TestField(Machinery, true);
        SalesOrderLine.TestField("Location Code");
        //SalesOrderLine.TestField("Ending Date");
        SalesOrderLine.TestField("Machine No.");

        Item.Get(SalesOrderLine."No.");
        WhseRcptLine."Entry No." := pEntryNo;

        WhseRcptLine."Original Item No." := SalesOrderLine."No.";
        WhseRcptLine."Confirmed Item No." := SalesOrderLine."No.";

        WhseRcptLine."Serial No." := SalesOrderLine."Machine No."; // A revisar

        WhseRcptLine."Rental Contract Ending Date" := SalesOrderLine."Ending Date";
        WhseRcptLine."Variant Code" := SalesOrderLine."Variant Code";
        //this won´t always be contract location but is an aproximation
        WhseRcptLine."Location Code" := SalesOrderLine."Location Code";
        WhseRcptLine."Origin Location Code" := SalesOrderLine."Location Code";

        WhseRcptLine."Bin Code" := RentalSetup."Review Pending Bin Code";
        WhseRcptLine."Origin Bin Code" := RentalSetup."Contract Bin Code";
        WhseRcptLine."Ship-to Contact Phone No." := WhseRectMgt.GetNumberPhone(SalesOrder."Ship-to Contact");

        Location.GET(WhseRcptLine."Origin Location Code");
        Location.TestField("Responsibility Center Code");
        WhseRcptLine."Responsibility Center Code" := Location."Responsibility Center Code";

        WhseRcptLine.Description := SalesOrderLine.Description;
        WhseRcptLine."Description 2" := SalesOrderLine."Description 2";

        WhseRcptLine.Quantity := SalesOrderLine.Quantity;
        WhseRcptLine."Qty. (Base)" := SalesOrderLine."Quantity (Base)";
        WhseRcptLine."Qty. Outstanding" := SalesOrderLine.Quantity;
        WhseRcptLine."Qty. Outstanding (Base)" := SalesOrderLine."Quantity (Base)";
        WhseRcptLine."Qty. per Unit of Measure" := SalesOrderLine."Qty. per Unit of Measure";
        WhseRcptLine."Qty. Received" := 0;
        WhseRcptLine."Qty. Received (Base)" := 0;
        WhseRcptLine."Qty. to Receive" := SalesOrderLine.Quantity;
        WhseRcptLine."Qty. to Receive (Base)" := SalesOrderLine."Quantity (Base)";
        WhseRcptLine."Unit of Measure Code" := SalesOrderLine."Unit of Measure Code";

        WhseRcptLine.SetSource(DATABASE::"Sales Line", SalesOrderLine."Document No.", SalesOrderLine."Line No.");
        WhseRcptLine.Status := WhseRcptLine.Status::" ";
        WhseRcptLine."Transport Responsible" := WhseRcptLine."Transport Responsible"::Company;

        SalesOrderLine.GetSalesHeader(SalesOrder, Currency);

        WhseRcptLine."Ship-to Customer No." := SalesOrder."Sell-to Customer No.";
        WhseRcptLine."Ship-to Address" := SalesOrder."Ship-to Address";
        WhseRcptLine."Ship-to Address 2" := salesorder."Ship-to Address 2";
        WhseRcptLine."Ship-to City" := salesorder."Ship-to City";
        WhseRcptLine."Ship-to County" := salesorder."Ship-to County";
        SalesOrder.TestField("Ship-to Post Code");
        salesorder.TestField("Ship-to Country/Region Code");
        WhseRcptLine."Ship-to Post Code" := salesorder."Ship-to Post Code";
        WhseRcptLine."Ship-to Country/Region Code" := salesorder."Ship-to Country/Region Code";
        WhseRcptLine."Ship-to Name" := salesorder."Ship-to Name";
        WhseRcptLine."Ship-to Name 2" := salesorder."Ship-to Name 2";
        WhseRcptLine."Parent Entry No." := WhseRectMgt.GetParentEntryNo(SalesOrderLine);
        WhseRcptLine.Business := SalesOrder.Business;
        WhseRcptLine."Rate Code" := SalesOrderLine."Rate Code";
        WhseRcptLine."Responsibility Center Code" := Location."Responsibility Center Code";

        WhseShptLine.Reset();
        WhseShptLine.SetRange("Source Type", DATABASE::"Sales Line");
        WhseShptLine.SetRange("Source No.", SalesOrderLine."Document No.");
        WhseShptLine.SetRange("Source Line No.", SalesOrderLine."Line No.");
        if WhseShptLine.FindFirst() then begin
            WhseRcptLine."Ship-to Contact" := WhseShptLine."Ship-to Contact";
            WhseRcptLine."Ship-to Contact Email" := WhseShptLine."Ship-to Contact Email";
            WhseRcptLine."Ship-to Contact Phone No." := WhseShptLine."Ship-to Contact Phone No.";
        end;

        if WhseRcptLine."Ship-to Contact Phone No." = '' then
            WhseRcptLine."Ship-to Contact Phone No." := WhseRectMgt.GetNumberPhone(SalesOrder."Ship-to Contact");

        WhseRcptLine."Rental Contract Ext.Doc.No." := SalesOrder."External Document No.";

        WhseRcptLine.Insert();

        SalesOrderLine.VALIDATE("Warehouse Qty. to Receive", 0);
        SalesOrderLine.modify();
    end;

    // ------ VOLCADO DE DATOS A LA BD

    procedure CrearLineaEnv(VAR tempWhShipLine: Record "RENT - Whse. Shipment Line" temporary)
    var
        hostWhShipLine: Record "RENT - Whse. Shipment Line";
        hostSalesLine: Record "Sales Line";
        ContLinea: Integer;
        LESalesLineType: Enum "Sales Line Type";
        RentWhseShptMgt: Codeunit "RENT - Whse. Shipment Mgt.";
    begin

        if tempWhShipLine.IsEmpty then
            exit;

        ContLinea := hostWhShipLine.Count * 1000;

        IF tempWhShipLine.FINDSET THEN
            repeat

                hostSalesLine.SetRange(Type, LESalesLineType::Item);
                hostSalesLine.SetRange("Document No.", tempWhShipLine."Source No.");
                hostSalesLine.SetRange("Line No.", tempWhShipLine."Source Line No.");
                hostSalesLine.FindFirst();

                hostSalesLine."Warehouse Qty. to Ship" := tempWhShipLine."Qty. to Ship";
                hostSalesLine.Modify();

                //Introducir datos en WhShipLine
                hostWhShipLine.SetRange("Source Type", Database::"RENT - Whse. Shipment Line");
                hostWhShipLine.SetRange("Source No.", tempWhShipLine."Source No.");
                hostWhShipLine.SetRange("Source Line No.", tempWhShipLine."Source Line No.");

                //Insercion de todos los campos creados con el procedure
                hostWhShipLine.TransferFields(tempWhShipLine);
                //Incrementamos el valor de la linea
                ContLinea += 1000;
                hostWhShipLine."Entry No." := ContLinea;
                hostWhShipLine.Insert();

                //Insercion de los campos del formulario
                hostWhShipLine."Original Item No." := tempWhShipLine."Original Item No.";
                hostWhShipLine.Description := tempWhShipLine.Description;
                hostWhShipLine."Shipment DateTime" := tempWhShipLine."Shipment DateTime";
                hostWhShipLine."Due DateTime" := tempWhShipLine."Due DateTime";
                hostWhShipLine."Transport Responsible" := tempWhShipLine."Transport Responsible";
                hostWhShipLine."Serial No." := tempWhShipLine."Serial No.";
                hostWhShipLine."Responsible Name" := tempWhShipLine."Responsible Name";
                hostWhShipLine."Responsible CIF/NIF" := tempWhShipLine."Responsible CIF/NIF";
                hostWhShipLine."Responsible Plate No." := tempWhShipLine."Responsible Plate No.";
                // -> Nuevo a checkear
                hostWhShipLine."Ship-to Contact" := tempWhShipLine."Ship-to Contact";
                hostWhShipLine."Ship-to Contact Phone No." := tempWhShipLine."Ship-to Contact Phone No.";
                hostWhShipLine."Ship-to Contact Email" := tempWhShipLine."Ship-to Contact Email";
                // -> Hasta aquí
                hostWhShipLine.Comment := tempWhShipLine.Comment;
                hostWhShipLine."Parent Entry No." := hostSalesLine."Attached Sales Line No.";
                hostWhShipLine.Modify();

                // Volcado a CRM
                RentWhseShptMgt.LogisticPlan_Request(hostWhShipLine);

            until tempWhShipLine.Next() = 0;
    end;

    // ------ CHECKEO DE CAMPOS ANTES DEL VOLCADO -------
    procedure CheckCamposEnv(var tempWhShipLine: Record "RENT - Whse. Shipment Line" temporary): Boolean;
    begin
        if tempWhShipLine.FindSet() then begin
            repeat
                tempWhShipLine.TestField(tempWhShipLine."Shipment DateTime");
                tempWhShipLine.TestField(tempWhShipLine."Due DateTime");
                tempWhShipLine.TestField(tempWhShipLine."Transport Responsible");
                if tempWhShipLine."Transport Responsible" = tempWhShipLine."Transport Responsible"::Customer then begin
                    tempWhShipLine.TestField(tempWhShipLine."Serial No.");
                    tempWhShipLine.TestField(tempWhShipLine."Responsible Name");
                    tempWhShipLine.TestField(tempWhShipLine."Responsible CIF/NIF");
                    tempWhShipLine.TestField(tempWhShipLine."Responsible Plate No.");
                end;
            until tempWhShipLine.Next() = 0;
            exit(true);
        end;
    end;

    procedure CrearLineaRec(VAR tempWhReceipLine: Record "RENT - Whse. Receipt Line" temporary)
    var
        hostWhReceipLine: Record "RENT - Whse. Receipt Line";
        hostSalesLine: Record "Sales Line";
        ContLinea: Integer;
        LESalesLineType: Enum "Sales Line Type";
        RentWhseShptMgt: Codeunit "RENT - Whse. Receipt Mgt."; // a revision
    begin

        if tempWhReceipLine.IsEmpty then
            exit;

        ContLinea := hostWhReceipLine.Count * 1000;

        IF tempWhReceipLine.FINDSET THEN
            repeat

                //Introducir dato en SalesLine -> A revisar

                hostSalesLine.SetRange(Type, LESalesLineType::Item);
                hostSalesLine.SetRange("Document No.", tempWhReceipLine."Source No.");
                hostSalesLine.SetRange("Line No.", tempWhReceipLine."Source Line No.");
                hostSalesLine.FindFirst();

                hostSalesLine."Warehouse Qty. to Receive" := tempWhReceipLine."Qty. to Receive";
                hostSalesLine.Modify();

                //Introducir datos en ReceipLine
                hostWhReceipLine.SetRange("Source Type", Database::"RENT - Whse. Shipment Line");
                hostWhReceipLine.SetRange("Source No.", tempWhReceipLine."Source No.");
                hostWhReceipLine.SetRange("Source Line No.", tempWhReceipLine."Source Line No.");

                //Insercion de todos los campos creados con el procedure
                hostWhReceipLine.TransferFields(tempWhReceipLine);
                //Incrementamos el valor de la linea
                ContLinea += 1000;
                hostWhReceipLine."Entry No." := ContLinea;
                hostWhReceipLine.Insert();

                //Insercion de los campos del formulario
                hostWhReceipLine."Original Item No." := tempWhReceipLine."Original Item No.";
                hostWhReceipLine.Description := tempWhReceipLine.Description;
                hostWhReceipLine."Receipt DateTime" := tempWhReceipLine."Receipt DateTime";
                hostWhReceipLine."Due DateTime" := tempWhReceipLine."Due DateTime";
                hostWhReceipLine."Transport Responsible" := tempWhReceipLine."Transport Responsible";
                hostWhReceipLine."Serial No." := tempWhReceipLine."Serial No.";
                hostWhReceipLine."Responsible Name" := tempWhReceipLine."Responsible Name";
                hostWhReceipLine."Responsible CIF/NIF" := tempWhReceipLine."Responsible CIF/NIF";
                hostWhReceipLine."Responsible Plate No." := tempWhReceipLine."Responsible Plate No.";
                hostWhReceipLine.Comment := tempWhReceipLine.Comment;
                hostWhReceipLine."Parent Entry No." := hostSalesLine."Attached Sales Line No.";

                hostWhReceipLine."Ship-to Contact" := tempWhReceipLine."Ship-to Contact";
                hostWhReceipLine."Ship-to Contact Phone No." := tempWhReceipLine."Ship-to Contact Phone No.";

                hostWhReceipLine.Modify();

                // Volcado a CRM
                RentWhseShptMgt.LogisticPlan_Request(hostWhReceipLine);

            until tempWhReceipLine.Next() = 0;
    end;

    // ------ CHECKEO DE CAMPOS ANTES DEL VOLCADO -------
    procedure CheckCamposRec(var tempWhReceipLine: Record "RENT - Whse. Receipt Line" temporary): Boolean;
    begin
        if tempWhReceipLine.FindSet() then begin
            repeat
                tempWhReceipLine.TestField(tempWhReceipLine."Receipt DateTime");
                tempWhReceipLine.TestField(tempWhReceipLine."Due DateTime");
                tempWhReceipLine.TestField(tempWhReceipLine."Transport Responsible");
                if tempWhReceipLine."Transport Responsible" = tempWhReceipLine."Transport Responsible"::Customer then begin
                    tempWhReceipLine.TestField(tempWhReceipLine."Serial No.");
                    tempWhReceipLine.TestField(tempWhReceipLine."Responsible Name");
                    tempWhReceipLine.TestField(tempWhReceipLine."Responsible CIF/NIF");
                    tempWhReceipLine.TestField(tempWhReceipLine."Responsible Plate No.");
                end;
            until tempWhReceipLine.Next() = 0;
            exit(true);
        end;
    end;
}