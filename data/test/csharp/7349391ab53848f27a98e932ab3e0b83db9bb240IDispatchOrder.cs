using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using Admin.Model.Product_MDL;
using System.Data;


namespace Admin.IDAL.Product_IDAL
{
    public interface IDispatchOrder
    {
        IList<DispatchOrder_MDL> selectDispatchOrder(int id, string status, string colname, string coltext, string indexs);
        IList<DispatchOrder_MDL> selectDispatchOrder(int id, string status, string colname, string coltext, string Machine_Code, string indexs);
        DataSet selectDispatchOrderDateSet(int id, string status, string colname, string coltext, string Machine_Code, string indexs);
        IList<DispatchOrder_MDL> selectDispatchOrder(int id, string status, string colname, string coltext);
        IList<DispatchOrder_MDL> selectDispatchOrder(int id, string colname, string coltext);
        IList<DispatchOrder_MDL> selectDispatchOrderDetail(int id, string colname, string coltext);
        IList<DispatchOrder_MDL> selectDispatchOrder(string status);
        IList<DispatchOrder_MDL> selectDispatchOrder(string CheckStatus, string DispatchStatus);
        IList<DispatchOrder_MDL> selectDispatchOrder(string MachineNo, int isBoo);
        IList<DispatchOrder_MDL> existsDispatchOrder(string vDO_No);
        IList<DispatchOrder_MDL> QueryWorkOrder();

        IList<DispatchOrder_MDL> existsDispatchOrder(string vDO_No, string vcolname);

        IList<DispatchOrder_MDL> existsDispatchOrder(string vDO_No, string vcolname, string status);

        void ChangeDispatchOrder(DispatchOrder_MDL Obj, string IU);
        void ChangeDispatchOrder(DispatchOrder_MDL Obj, string IU, out int xid);

        //void checkDispatchOrder(int vID, string vChecker, string flag);
        void deleteDispatchOrder(int ID);
        void cancelDispatchOrder(ArrayList IDList);
        void checkDispatchOrder(string strFlag, string strUserID, ArrayList IDList);
    }
}
