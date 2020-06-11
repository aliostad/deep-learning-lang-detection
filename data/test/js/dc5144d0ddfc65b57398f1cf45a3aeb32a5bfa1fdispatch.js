

        function loadDispatchJson(ginNo, type) {

            var params = {};
            params['ginNo'] = ginNo;
            params['type'] = type;
            $('#dispatch_partial').load("/Dispatch/_DispatchPartial/", {ginNo : ginNo});
            $.getJSON('@Url.Action("JsonDispatch", "Dispatch")', params, function (dispatch) {
                $('#ajax_loading').hide();
                if (dispatch == null) {
                    return;
                }
                $('#DispatchID').val(dispatch.DispatchID);
                $('#RequisitionNo').val(dispatch.RequisitionNo);
                $('#WarehouseID').val(dispatch.WarehouseID);
                $('#WarehouseID').change();
                $('#TransporterID').val(dispatch.TransporterID);
                $('#DriverName').val(dispatch.DriverName);
                $('#PlateNo_Prime').val(dispatch.PlateNo_Prime);
                $('#PlateNo_Trailer').val(dispatch.PlateNo_Trailer);
                $('#BidNumber').val(dispatch.BidNumber);
                var datePicker = $("#DispatchDate").data("tDatePicker");
                datePicker.value(parseJsonDate(dispatch.DispatchDate));
                $('#Year').val(dispatch.Year);
                $('#Year').change();
                $('#Month').val(dispatch.Month);
                $('#ProgramID').val(dispatch.ProgramID);
                $('#WeighBridgeTicketNumber').val(dispatch.WeighBridgeTicketNumber);
                $('#Remark').val(dispatch.Remark);
                var gr = $('#dispatchCommoditiesGrid').data('tGrid');
                gr.rebind({ dispatchId: dispatch.DispatchID });

                $('#SelectedRegionId').jCombo("/AdminUnit/GetRegions", {
                    selected_value: '3'
                });
                $('#SelectedZoneId').jCombo("/AdminUnit/GetChildren?unitId=", {
                    parent: "#SelectedRegionId",
                    parent_value: '3',
                    selected_value: '7'
                });

                $('#SelectedWoredaId').jCombo("/AdminUnit/GetChildren?unitId=", {
                    parent: "#SelectedZoneId",
                    parent_value: '7',
                    selected_value: '8'
                });
                $('#FDPID').jCombo("/FDP/GetFDPs?woredaId=", {
                    parent: "#SelectedWoredaId",
                    parent_value: '8',
                    selected_value: '1'
                });

            });
        }


        function initDispatchCascade(){
             $('#SelectedRegionId').cascade({
            url: '/AdminUnit/GetChildren/',
            paramName: 'unitId',
            childSelect: $('#SelectedZoneId')
        });

        $('#SelectedZoneId').cascade({
            url: '/AdminUnit/GetChildren/',
            paramName: 'unitId',
            childSelect: $('#SelectedWoredaId')
        });

        $('#SelectedWoredaId').cascade({
            url: '/FDP/GetFDPs/',
            paramName: 'woredaId',
            childSelect: $('#FDPID')
        });
       
        $('#StoreID').cascade({
            url: '/Store/StackNumbers/',
            paramName: 'storeId',
            childSelect: $('#StackNumber')
        });

        $('#Year').cascade({
            url: '/Dispatch/Months/',
            paramName: 'year',
            childSelect: $('#Month')
        });
        
   }

   function loadDispatch(ginNo, type) {

            var params = {};
            params['ginNo'] = ginNo;
            params['type'] = type;
            $('#dispatch_partial').load("/Dispatch/_DispatchPartial", params);
            
        }