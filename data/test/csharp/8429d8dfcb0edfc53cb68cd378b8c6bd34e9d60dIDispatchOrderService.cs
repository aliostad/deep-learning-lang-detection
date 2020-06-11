using System;
using System.Collections.Generic;
using MODEL;

namespace SERVICE.IService
{
    public interface IDispatchOrderService
    {
        bool SaveDispatchOrder(DispatchOrderModel dispatchOrderModel);
        DispatchOrderModel GetDispatchOrderDetailByDispatchOrderId(int dispatchOrderNumber);
        List<DispatchOrderModel> Getdispatchorder();
        Boolean EditDispatchOrderSumamry(DispatchOrderModel dispatchOrderModel);
        List<DispatchOrderDetailModel> GetDispatchOrderDetailByDispatchOrderid(int dispatchorderod);
        Boolean UpdateDispatchOrderSumamry(DispatchOrderModel dispatchOrderModel);
        List<ProductModel> getproductnameNotcheckedbyfinance();
        List<ProductModel> GetdataByProductId(int Productid);
       

    }
}