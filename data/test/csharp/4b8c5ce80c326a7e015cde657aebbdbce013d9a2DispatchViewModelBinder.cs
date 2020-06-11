using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Cats.Models.Hubs;

namespace Cats.ViewModelBinder
{
    public class DispatchViewModelBinder
    {
        public static DispatchViewModel BindDispatchViewModelBinder(Dispatch dispatch)
        {
            var dispatchViewModel = new DispatchViewModel();
            var dispatchDetail = dispatch.DispatchDetails.FirstOrDefault();
            dispatchViewModel.BidNumber = dispatch.BidNumber;
            dispatchViewModel.DispatchDate = dispatch.DispatchDate;
            dispatchViewModel.DispatchID = dispatch.DispatchID;
            dispatchViewModel.DispatchedByStoreMan = dispatch.DispatchedByStoreMan;
            dispatchViewModel.DriverName = dispatch.DriverName;
            dispatchViewModel.FDP = dispatch.FDP.Name;
            dispatchViewModel.GIN = dispatch.GIN;
            dispatchViewModel.Month = dispatch.PeriodMonth;
            dispatchViewModel.PlateNo_Prime = dispatch.PlateNo_Prime;
            dispatchViewModel.PlateNo_Trailer = dispatch.PlateNo_Trailer;
            //dispatchViewModel.Program = dispatch.program;
          
            dispatchViewModel.Remark = dispatch.Remark;
            dispatchViewModel.RequisitionNo = dispatch.RequisitionNo;
            dispatchViewModel.Round = dispatch.Round;
          
            dispatchViewModel.Type = dispatch.Type;
            dispatchViewModel.WeighBridgeTicketNumber = dispatch.WeighBridgeTicketNumber;
            dispatchViewModel.Year = dispatch.PeriodYear;
            if (dispatch.DispatchAllocation.ShippingInstruction != null)
                dispatchViewModel.SINumber = dispatch.DispatchAllocation.ShippingInstruction.Value;
            if (dispatch.DispatchAllocation.ProjectCode != null)
                dispatchViewModel.ProjectNumber = dispatch.DispatchAllocation.ProjectCode.Value;
            //if (dispatchDetail != null)
            //{
            //    dispatchViewModel.CommodityID = dispatchDetail.CommodityID;
            //    dispatchViewModel.Commodity = dispatchDetail.Commodity.Name;

            //}
            if(dispatch.DispatchAllocationID.HasValue)
            dispatchViewModel.DispatchAllocationID = dispatch.DispatchAllocationID.Value;
            return dispatchViewModel;
        }
    }
}