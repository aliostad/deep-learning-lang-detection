using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using Model;

namespace DAL
{
    /// <summary>
    /// 实体转换
    /// </summary>
    public class EntityConvert
    {
        /// <summary>
        /// 把数据行转换为DispatchList对象
        /// </summary>
        /// <param name="row"></param>
        /// <returns></returns>
        public static DispatchList ConvertToDispatchList(DataRow row)
        {
            DispatchList dispatchList = new DispatchList();
            dispatchList.cVouchType = Cast.ToString(row["cVouchType"]);
            dispatchList.cVouchName = Cast.ToString(row["cVouchName"]);
            dispatchList.cDLCode = Cast.ToString(row["cDLCode"]);
            dispatchList.dDate = Cast.ToDateTime(row["dDate"]);
            dispatchList.SBVID = Cast.ToInteger(row["SBVID"]);//发票主表标识
            dispatchList.cSBVCode = Cast.ToString(row["cSBVCode"]);//发票号
            dispatchList.cBusType = Cast.ToString(row["cBusType"]);
            dispatchList.DLID = Cast.ToInteger(row["DLID"]);
            dispatchList.cSTCode = Cast .ToString(row["cSTCode"]);
            dispatchList.cSTName = Cast.ToString(row["cSTName"]);
            dispatchList.cCusCode = Cast.ToString(row["cCusCode"]);
            dispatchList.cCusAbbName = Cast.ToString(row["cCusAbbName"]);
            dispatchList.cCusName = Cast.ToString(row["cCusName"]);
            dispatchList.cDepCode = Cast.ToString(row["cDepCode"]);
            dispatchList.cDepName = Cast.ToString(row["cDepName"]);
            dispatchList.cPersonCode = Cast.ToString(row["cPersonCode"]);
            dispatchList.cPersonName = Cast.ToString(row["cPersonName"]);
            dispatchList.cMaker = Cast.ToString(row["cMaker"]);
            dispatchList.cVerifier = Cast.ToString(row["cVerifier"]);
            dispatchList.cShipAddress = Cast.ToString(row["cShipAddress"]);
            dispatchList.ufts = Cast.ToString(row["ufts"]);
            dispatchList.cDefine1 = Cast.ToString(row["cDefine1"]);
            dispatchList.cDefine2 = Cast.ToString(row["cDefine2"]);
            dispatchList.cDefine3 = Cast.ToString(row["cDefine3"]);
            dispatchList.cDefine4 = Cast.ToDateTime(row["cDefine4"]);
            dispatchList.cDefine5 = Cast.ToInteger(row["cDefine5"]);
            dispatchList.cDefine6 = Cast.ToDateTime(row["cDefine6"]);
            dispatchList.cDefine7 = Cast.ToDouble(row["cDefine7"]);
            dispatchList.cDefine8 = Cast.ToString(row["cDefine8"]);
            dispatchList.cDefine9 = Cast.ToString(row["cDefine9"]);
            dispatchList.cDefine10 = Cast.ToString(row["cDefine10"]);
            dispatchList.cDefine11 = Cast.ToString(row["cDefine11"]);
            dispatchList.cDefine12 = Cast.ToString(row["cDefine12"]);
            dispatchList.cDefine13 = Cast.ToString(row["cDefine13"]);
            dispatchList.cDefine14 = Cast.ToString(row["cDefine14"]);
            dispatchList.cDefine15 = Cast.ToInteger(row["cDefine15"]);
            dispatchList.cDefine16 = Cast.ToDouble(row["cDefine16"]);
            dispatchList.cMemo = Cast.ToString(row["cMemo"]);
            dispatchList.bReturnFlag = Cast.ToBoolean(row["bReturnFlag"]);

            return dispatchList;
        }

        /// <summary>
        /// 把数据行转换为Dispatchlists对象
        /// </summary>
        /// <param name="row"></param>
        /// <returns></returns>
        public static DispatchLists ConvertToDispatchLists(DataRow row)
        {
            DispatchLists dispatchLists = new DispatchLists();
            dispatchLists.DLID = Cast.ToInteger(row["DLID"]);
            dispatchLists.AutoID = Cast.ToInteger(row["AutoID"]);
            dispatchLists.cDLCode = Cast.ToString(row["cDLCode"]);
            dispatchLists.iSOsID = Cast.ToInteger(row["iSOsID"]);
            dispatchLists.iDLsID = Cast.ToInteger(row["iDLsID"]);
            dispatchLists.cSoCode = Cast.ToString(row["cSoCode"]);

            dispatchLists.cWhCode = Cast.ToString(row["cWhCode"]);
            dispatchLists.cWhName = Cast.ToString(row["cWhName"]);
            //存货
            dispatchLists.cInvCode = Cast.ToString(row["cInvCode"]);
            dispatchLists.cInvName = Cast.ToString(row["cInvName"]);
            dispatchLists.cInvStd = Cast.ToString(row["cInvStd"]);
            dispatchLists.cBatch = Cast.ToString(row["cBatch"]);
            dispatchLists.cMassUnit = Cast.ToInteger(row["cMassUnit"]);
            dispatchLists.iMassDate = Cast.ToInteger(row["iMassDate"]);
            dispatchLists.cinvm_unit = Cast.ToString(row["cinvm_unit"]);
            //日期
            dispatchLists.dMDate = Cast.ToDateTime(row["dMDate"]);
            dispatchLists.dVDate = Cast.ToDateTime(row["dVDate"]);
            dispatchLists.iExpiratDateCalcu = Cast.ToInteger(row["iExpiratDateCalcu"]);
            dispatchLists.dExpirationdate = Cast.ToDateTime(row["dExpirationdate"]);
            dispatchLists.cExpirationdate = Cast.ToString(row["cExpirationdate"]);

            dispatchLists.iQuotedPrice = Cast.ToDouble(row["iQuotedPrice"]);
            //原币
            dispatchLists.iUnitPrice = Cast.ToDouble(row["iUnitPrice"]);
            dispatchLists.iTaxUnitPrice = Cast.ToDouble(row["iTaxUnitPrice"]);
            dispatchLists.iMoney = Cast.ToDouble(row["iMoney"]);
            dispatchLists.iTax = Cast.ToDouble(row["iTax"]);
            dispatchLists.iDisCount = Cast.ToDouble(row["iDisCount"]);
            dispatchLists.iSum = Cast.ToDouble(row["iSum"]);

            dispatchLists.iNatUnitPrice = Cast.ToDouble(row["iNatUnitPrice"]);
            dispatchLists.iNatMoney = Cast.ToDouble(row["iNatMoney"]);
            dispatchLists.iNatTax = Cast.ToDouble(row["iNatTax"]);
            dispatchLists.iNatSum = Cast.ToDouble(row["iNatSum"]);
            dispatchLists.iNatDisCount = Cast.ToDouble(row["iNatDisCount"]);

            dispatchLists.iTaxRate = Cast.ToDouble(row["iTaxRate"]);
            //数量
            dispatchLists.iQuantity = Cast.ToDouble(row["iQuantity"]);
            dispatchLists.iNum = Cast.ToDouble(row["iNum"]);
            dispatchLists.fOutQuantity = Cast.ToDouble(row["fOutQuantity"]);
            dispatchLists.fOutNum = Cast.ToDouble(row["fOutNum"]);
            //单价金额
            dispatchLists.fSaleCost = Cast.ToDouble(row["fSaleCost"]);
            dispatchLists.fSalePrice = Cast.ToDouble(row["fSalePrice"]);

            dispatchLists.iSettleNum = Cast.ToDouble(row["iSettleNum"]);
            dispatchLists.iSettleQuantity = Cast.ToDouble(row["iSettleQuantity"]);
            dispatchLists.bSettleAll = Cast.ToBoolean(row["bSettleAll"]);
            dispatchLists.cFree1 = Cast.ToString(row["cFree1"]);
            dispatchLists.cFree2 = Cast.ToString(row["cFree2"]);
            dispatchLists.iTB = Cast.ToInteger(row["iTB"]);
            dispatchLists.KL = Cast.ToDouble(row["KL"]);
            dispatchLists.KL2 = Cast.ToDouble(row["KL2"]);
            dispatchLists.bIsSTQc = Cast.ToBoolean(row["bIsSTQc"]);
            dispatchLists.bGsp = Cast.ToBoolean(row["bGsp"]);

            dispatchLists.bCosting = Cast.ToBoolean(row["bCosting"]);
            dispatchLists.iInvExchRate = Cast.ToDouble(row["iInvExchRate"]);

            //订单行号
            dispatchLists.iorderrowno = Cast.ToInteger(row["iorderrowno"]);
            return dispatchLists;
        }
    }
}
