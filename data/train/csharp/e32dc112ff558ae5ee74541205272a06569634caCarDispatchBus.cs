/**********************************************
 * 类作用：   车辆派车事务层处理
 * 建立人：   lysong
 * 建立时间： 2009/04/29
 ***********************************************/
using System;
using XBase.Model.Office.AdminManager;
using XBase.Data.Office.AdminManager;
using XBase.Common;
using System.Data;
namespace XBase.Business.Office.AdminManager
{
    /// <summary>
    /// 类名：CarApplyBus
    /// 描述：车辆派车事务层处理
    /// 作者：lysong
    /// 创建时间：2009/04/29
    /// </summary>
   public class CarDispatchBus
   {
       #region 获取请车单据号下拉列表(出去未归还的车辆)
       /// <summary>
        /// 获取请车单据号下拉列表
        /// </summary>
        /// <returns></returns>
       public static DataTable GetCarApplyNo(string CompanyCD, int EmployeeID)
        {
            return CarDispatchDBHelper.GetCarApplyNo(CompanyCD, EmployeeID);
        }

        #endregion
       #region 获取请车单据号下拉列表（出车和未出车的都包括）
       /// <summary>
       /// 获取请车单据号下拉列表
       /// </summary>
       /// <returns></returns>
       public static DataTable GetAllCarApplyNo(string CompanyCD)
       {
           return CarDispatchDBHelper.GetAllCarApplyNo(CompanyCD);
       }
       #endregion

       #region 添加车辆派送信息
       /// <summary>
       /// 添加车辆派送信息
       /// </summary>
       /// <param name="CarDispatchM">车辆派送信息</param>
       /// <returns>添加是否成功 false:失败，true:成功</returns>
       public static bool InsertCarDispatchInfoData(CarDispatchModel CarDispatchM, out int RetValID)
       {
           return CarDispatchDBHelper.InsertCarDispatchInfoData(CarDispatchM, out RetValID);
       }
       #endregion

       #region 获取车辆派送数据
       /// <summary>
       /// 获取车辆派送数据
       /// </summary>
       /// <returns>DataTable</returns>
       public static DataTable GetCarDispatchList(string CompanyID, string RecordNo, string DispatchTitle, string ApplyID, string CarNo, string CarMark, string IfReturn,int pageIndex,int pageCount,string ord, ref int TotalCount)
       {
           try
           {
               return CarDispatchDBHelper.GetCarDispatchList(CompanyID, RecordNo, DispatchTitle, ApplyID, CarNo, CarMark, IfReturn, pageIndex, pageCount, ord, ref TotalCount);
           }

           catch (System.Exception ex)
           {
               throw ex;
           }
       }
       #endregion

       #region  根据派车ID获取派车信息
       /// <summary>
       /// 根据派车ID获取派车信息
       /// </summary>
       /// <param name="DispatchID">派车ID</param>
       /// <returns>DataTable</returns>
       public static DataTable GetCarDispatchByID(string DispatchID)
       {
           try
           {
               return CarDispatchDBHelper.GetCarDispatchByID(DispatchID);
           }
           catch (System.Exception ex)
           {
               throw ex;
           }
       }
       public static DataTable GetCarDispatchByIDPrint(string DispatchID)
       {
           try
           {
               return CarDispatchDBHelper.GetCarDispatchByIDPrint(DispatchID);
           }
           catch (System.Exception ex)
           {
               throw ex;
           }
       }
       #endregion

       #region 更新车辆归还信息
       /// <summary>
       /// 更新车辆归还信息
       /// </summary>
       /// <param name="CarDispatchM">车辆归还信息</param>
       /// <returns>添加是否成功 false:失败，true:成功</returns>
       public static bool UpdateCarDispatchInfoData(CarDispatchModel CarDispatchM, string DispatchID)
       {
           return CarDispatchDBHelper.UpdateCarDispatchInfoData(CarDispatchM, DispatchID);
       }
       #endregion

       #region 更新车辆派送信息
       /// <summary>
       /// 更新车辆派送信息
       /// </summary>
       /// <param name="CarDispatchM">车辆派送信息</param>
       /// <returns>添加是否成功 false:失败，true:成功</returns>
       public static bool UpdateCarDispatchInfoData(CarDispatchModel CarDispatchM)
       {
           return CarDispatchDBHelper.UpdateCarDispatchInfoData(CarDispatchM);
       }
       #endregion
    }
}
