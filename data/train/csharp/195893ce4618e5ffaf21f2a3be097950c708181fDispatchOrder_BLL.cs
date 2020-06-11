using System;
using System.Data;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using Admin.Model.Product_MDL;
using Admin.IDAL.Product_IDAL;

namespace Admin.BLL.Product_BLL
{
   public class DispatchOrder_BLL
   {
       private static readonly IDispatchOrder factory = Admin.DALFactory.DataAccess.selectDispatchOrder();

       public static IList<DispatchOrder_MDL> selectDispatchOrder(int id, string status, string colname, string coltext, string indexs)
       {
           return factory.selectDispatchOrder(id, status, colname, coltext, indexs);
       }
       public static IList<DispatchOrder_MDL> selectDispatchOrder(int id, string status, string colname, string coltext,string Machine_Code, string indexs)
       {
           return factory.selectDispatchOrder(id, status, colname, coltext,Machine_Code, indexs);
       }
       public static DataSet selectDispatchOrderDateSet(int id, string status, string colname, string coltext, string Machine_Code, string indexs)
       {
           return factory.selectDispatchOrderDateSet(id, status, colname, coltext, Machine_Code, indexs);
       }
       public static IList<DispatchOrder_MDL> selectDispatchOrder(int id, string status, string colname, string coltext)
       {
           return factory.selectDispatchOrder(id, status, colname, coltext);
       }
       public static IList<DispatchOrder_MDL> selectDispatchOrder(int id,  string colname, string coltext)
       {
           return factory.selectDispatchOrder(id,  colname, coltext);
       }
       public static IList<DispatchOrder_MDL> selectDispatchOrderDetail(int id, string colname, string coltext)
       {
           return factory.selectDispatchOrderDetail(id, colname, coltext);
       }
       
       public static IList<DispatchOrder_MDL> selectDispatchOrder(string status)
       {
           return factory.selectDispatchOrder(status);
       }
       public static IList<DispatchOrder_MDL> selectDispatchOrder(string CheckStatus, string DispatchStatus)
       {
           return factory.selectDispatchOrder(CheckStatus,DispatchStatus);
       }

       public static IList<DispatchOrder_MDL> selectDispatchOrder(string MachineNo, int isBoo)
       {
           return factory.selectDispatchOrder(MachineNo, isBoo);
       }

       public static IList<DispatchOrder_MDL> existsDispatchOrder(string vDO_No)
       {
           return factory.existsDispatchOrder(vDO_No);
       }
       public static IList<DispatchOrder_MDL> existsDispatchOrder(string vDO_No,string vcolname)
       {
           return factory.existsDispatchOrder(vDO_No, vcolname);
       }
       public static IList<DispatchOrder_MDL> existsDispatchOrder(string vDO_No, string vcolname, string status)
       {
           return factory.existsDispatchOrder(vDO_No, vcolname, status);
       }
       public static IList<DispatchOrder_MDL> QueryWorkOrder()
       {
           return factory.QueryWorkOrder();
       }

       public static void ChangeDispatchOrder(int vID,
            string vDO_No, string vWorkOrderNo, string vMachineNo, string vMouldNo, string vProductNo,string vProductDesc,
            string vStartDate, string vStopDate, string vActualStartDate,
             string vActualStopDate, string vBadQty, string vDispatchDate, string vDispatchNum, string vCheckStatus, string vDispatchStatus, string vRemark, string vStandCycle, string IU)
       {
           DispatchOrder_MDL Obj = new DispatchOrder_MDL(vID,
             vDO_No, vWorkOrderNo, vMachineNo, vMouldNo, vProductNo,vProductDesc, 
             vStartDate, vStopDate, vActualStartDate,
             vActualStopDate, vBadQty, vDispatchDate, vDispatchNum, vCheckStatus, vDispatchStatus, vRemark, vStandCycle);
           factory.ChangeDispatchOrder(Obj, IU);
       }
       public static void ChangeDispatchOrder(int vID,
           string vDO_No, string vWorkOrderNo, string vMachineNo, string vMouldNo, string vProductNo,string vProductDesc,
           string vStartDate, string vStopDate, string vActualStartDate,
           string vActualStopDate, string vBadQty, string vDispatchDate, string vDispatchNum,string vCheckStatus, string vDispatchStatus, string vRemark,string vStandCycle, string IU,out int xid)
       {
           DispatchOrder_MDL Obj = new DispatchOrder_MDL(vID,
             vDO_No, vWorkOrderNo, vMachineNo, vMouldNo, vProductNo,vProductDesc,
             vStartDate, vStopDate, vActualStartDate,
             vActualStopDate, vBadQty, vDispatchDate, vDispatchNum, vCheckStatus, vDispatchStatus, vRemark, vStandCycle);
           factory.ChangeDispatchOrder(Obj, IU, out xid);
       }

       public static void ChangeDispatchOrder(int vID,
           string vDO_No, string vWorkOrderNo, string vMachineNo, string vMouldNo, string vProductNo,string vProductDesc,
           string vStartDate, string vStopDate, string vActualStartDate,
           string vActualStopDate, string vBadQty, string vDispatchDate, string vDispatchNum,string vCheckStatus, string vDispatchStatus, string vRemark,string vStandCycle,string MaxInjectionCycle,string MinInjectionCycle,string UpdateCycleStatus,string vCreater, string IU,out int xid)
       {
           DispatchOrder_MDL Obj = new DispatchOrder_MDL(vID,
             vDO_No, vWorkOrderNo, vMachineNo, vMouldNo, vProductNo,vProductDesc,
             vStartDate, vStopDate, vActualStartDate,
             vActualStopDate, vBadQty, vDispatchDate, vDispatchNum, vCheckStatus, vDispatchStatus, vRemark, vStandCycle, MaxInjectionCycle, MinInjectionCycle, UpdateCycleStatus, vCreater);
           factory.ChangeDispatchOrder(Obj, IU, out xid);
       }

       public static void deleteDispatchOrder(int ID)
       {
           factory.deleteDispatchOrder(ID);
       }

       public static void cancelDispatchOrder(ArrayList IDList)
       {
           factory.cancelDispatchOrder(IDList);
       }

       public static void checkDispatchOrder(string strFlag, string strUserID, ArrayList IDList)
       {
           factory.checkDispatchOrder(strFlag, strUserID, IDList);
       }

       
    }
}
