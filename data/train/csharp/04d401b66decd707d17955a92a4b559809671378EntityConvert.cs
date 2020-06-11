using System;
using System.Linq;
using System.Collections.Generic;
using System.Text;
using Model;

namespace UI
{
    /// <summary>
    /// 实体转换
    /// </summary>
    public class EntityConvert
    {
        #region 库存管理

        /// <summary>
        /// 把销售发货主表对象转换成销售出库主表对象
        /// </summary>
        /// <param name="dispatchList"></param>
        /// <returns></returns>
        public static RdRecord ConvertToRdrecord(DispatchList dispatchList)
        {
            RdRecord rdRecord = new RdRecord();

            //rdRecord.cVouchName = "销售出库单";//VouchType字典表
            //rdRecord.cVouchType = "32";
            rdRecord.cRdCode = "201";//数据表rd_style
            //rdRecord.cRdName = "销售出库";

            rdRecord.cWhCode = dispatchList.cWhCode;
            rdRecord.cWhName = dispatchList.cWhName;
            //rdRecord.bIsSTQc = dispatchList.bIsSTQc;
            //rdRecord.bRdFlag = dispatchList.bRdFlag;
            rdRecord.cAccounter = dispatchList.cAccounter;
            rdRecord.cAddCode = dispatchList.caddcode;
            rdRecord.cBillCode = dispatchList.SBVID;//发票主表标识
            rdRecord.isalebillid = dispatchList.cSBVCode;//发票号
            //来源单据：判断发票号是否空，如果为空则为发货单号，否则为发票号（即零售日报号）
            rdRecord.cBusCode = string.IsNullOrEmpty(dispatchList.cSBVCode) ? dispatchList.cDLCode : dispatchList.cSBVCode;
            rdRecord.cBusType = dispatchList.cBusType;
            //rdRecord.cChkCode = dispatchList.cchkcode;
            //rdRecord.cChkPerson = dispatchList.cchkperson;
            //rdRecord.cCode = dispatchList;
            rdRecord.cContactName = dispatchList.cContactName;
            rdRecord.cCusAbbName = dispatchList.cCusAbbName;
            //rdRecord.ccusaddress = dispatchList.ccusaddress;
            rdRecord.cCusCode = dispatchList.cCusCode;
            //rdRecord.ccushand = dispatchList.ccushand;
            rdRecord.ccusperson = dispatchList.ccusperson;
            //rdRecord.ccusphone = dispatchList.ccusphone;
            rdRecord.cDefine1 = dispatchList.cDefine1;
            rdRecord.cDefine2 = dispatchList.cDefine2;
            rdRecord.cDefine3 = dispatchList.cDefine3;
            rdRecord.cDefine4 = dispatchList.cDefine4;
            rdRecord.cDefine5 = dispatchList.cDefine5;
            rdRecord.cDefine6 = dispatchList.cDefine6;
            rdRecord.cDefine7 = dispatchList.cDefine7;
            rdRecord.cDefine8 = dispatchList.cDefine8;
            rdRecord.cDefine9 = dispatchList.cDefine9;
            rdRecord.cDefine10 = dispatchList.cDefine10;
            rdRecord.cDefine11 = dispatchList.cDefine11;
            rdRecord.cDefine12 = dispatchList.cDefine12;
            rdRecord.cDefine13 = dispatchList.cDefine13;
            rdRecord.cDefine14 = dispatchList.cDefine14;
            rdRecord.cDefine15 = dispatchList.cDefine15;
            rdRecord.cDefine16 = dispatchList.cDefine16;
            rdRecord.cdeliverunit = dispatchList.cdeliverunit;
            rdRecord.cDepCode = dispatchList.cDepCode;
            rdRecord.cDepName = dispatchList.cDepName;
            rdRecord.DLID = dispatchList.DLID;
            rdRecord.cDLCode = dispatchList.cDLCode;
            //rdRecord.cHandler = dispatchList.chandler;
            //rdRecord.cMaker = dispatchList.cMaker;
            rdRecord.cMemo = dispatchList.cMemo;
            rdRecord.cmobilephone = dispatchList.cmobilephone;
            //rdRecord.cModifyPerson = dispatchList.cmodifier;
            rdRecord.cofficephone = dispatchList.cofficephone;
            //rdRecord.contactmobile = dispatchList.contactmobile;
            //rdRecord.contactphone = dispatchList.contactphone;
            rdRecord.cPersonCode = dispatchList.cPersonCode;
            rdRecord.cPersonName = dispatchList.cPersonName;
            //rdRecord.cRdCode = dispatchList.cRdCode;
            //rdRecord.cRdName = dispatchList.cRdName;
            rdRecord.cShipAddress = dispatchList.cShipAddress;
            rdRecord.cSource = dispatchList.cVouchName;
            rdRecord.cSTCode = dispatchList.cSTCode;
            rdRecord.cSTName = dispatchList.cSTName;
            //rdRecord.cVenAbbName = dispatchList.;
            //rdRecord.cVenCode = dispatchList.cvencode;
            //rdRecord.cWhName = dispatchList.cwhname;
            //rdRecord.dChkDate = dispatchList.dchkdate;
            //rdRecord.dDate = MainForm.OperateTime; //单据日期
            //rdRecord.dModifyDate = dispatchList.dmoddate;
            //rdRecord.dnmaketime =DateTime.Now;// dispatchList;
            //rdRecord.dnmodifytime = dispatchList.dmodifysystime;
            //rdRecord.dnverifytime = dispatchList.dverifysystime;
            //rdRecord.dVeriDate = dispatchList.dverifydate;
            //rdRecord.gspcheck = dispatchList.;
            rdRecord.iarriveid= dispatchList.cDLCode;//发货退货单号
            //rdRecord.iAvaNum = dispatchList.iav;
            //rdRecord.iAvaQuantity = dispatchList.iav;
            //rdRecord.ID=;
            //rdRecord.iLowSum = dispatchList.;
            //rdRecord.ipresent = dispatchList.ipr;
            //rdRecord.iPresentNum = dispatchList.ipr;
            //rdRecord.ireturncount = dispatchList.ireturncount;
            //rdRecord.iSafeSum =;
            rdRecord.iswfcontrolled= dispatchList.iswfcontrolled;
            //rdRecord.iTopSum=;
            //rdRecord.iverifystate = dispatchList.iverifystate;
            //rdRecord.iVTid = ;
            rdRecord.ufts = dispatchList.ufts;

            return rdRecord;
        }

        /// <summary>
        /// 把销售发货子表转换成销售出库子表对象
        /// </summary>
        /// <param name="dispatchLists"></param>
        /// <returns></returns>
        public static RdRecords ConvertToRdrecords(DispatchLists dispatchLists)
        {
            RdRecords rdRecords = new RdRecords();
            //rdRecords.AutoID;
            rdRecords.bCosting = dispatchLists.bCosting;
            rdRecords.bGsp = dispatchLists.bGsp;
            rdRecords.cWhCode = dispatchLists.cWhCode;
            rdRecords.cWhName = dispatchLists.cWhName;
            //rdRecords.bVMIUsed;
            //rdRecords.cAssUnit = dispatchLists.cav;
            rdRecords.cbaccounter = dispatchLists.cbaccounter;
            //rdRecords.cBarCode = dispatchLists.cBarCode;
            rdRecords.cBatch = dispatchLists.cBatch;
            rdRecords.cBatchProperty1 = dispatchLists.cBatchProperty1;
            rdRecords.cBatchProperty2 = dispatchLists.cBatchProperty2;
            rdRecords.cBatchProperty3 = dispatchLists.cBatchProperty3;
            rdRecords.cBatchProperty4 = dispatchLists.cBatchProperty4;
            rdRecords.cBatchProperty5 = dispatchLists.cBatchProperty5;
            rdRecords.cBatchProperty6 = dispatchLists.cBatchProperty6;
            rdRecords.cBatchProperty7 = dispatchLists.cBatchProperty7;
            rdRecords.cBatchProperty8 = dispatchLists.cBatchProperty8;
            rdRecords.cBatchProperty9 = dispatchLists.cBatchProperty9;
            rdRecords.cBatchProperty10 = dispatchLists.cBatchProperty10;
            rdRecords.cbdlcode = dispatchLists.cDLCode;
            rdRecords.cCusInvCode = dispatchLists.cCusInvCode;
            rdRecords.cCusInvName = dispatchLists.cCusInvName;
            rdRecords.cDefine22 = dispatchLists.cDefine22;
            rdRecords.cDefine23 = dispatchLists.cDefine23;
            rdRecords.cDefine24 = dispatchLists.cDefine24;
            rdRecords.cDefine25 = dispatchLists.cDefine25;
            rdRecords.cDefine26 = dispatchLists.cDefine26;
            rdRecords.cDefine27 = dispatchLists.cDefine27;
            rdRecords.cDefine28 = dispatchLists.cDefine28;
            rdRecords.cDefine29 = dispatchLists.cDefine29;
            rdRecords.cDefine30 = dispatchLists.cDefine30;
            rdRecords.cDefine31 = dispatchLists.cDefine31;
            rdRecords.cDefine32 = dispatchLists.cDefine32;
            rdRecords.cDefine33 = dispatchLists.cDefine33;
            rdRecords.cDefine34 = dispatchLists.cDefine34;
            rdRecords.cDefine35 = dispatchLists.cDefine35;
            rdRecords.cDefine36 = dispatchLists.cDefine36;
            rdRecords.cDefine37= dispatchLists.cDefine37;
            rdRecords.cExpirationdate = dispatchLists.cExpirationdate;
            rdRecords.cFree1= dispatchLists.cFree1;
            rdRecords.cFree2= dispatchLists.cFree2;
            rdRecords.cFree3= dispatchLists.cFree3;
            rdRecords.cFree4= dispatchLists.cFree4;
            rdRecords.cFree5= dispatchLists.cFree5;
            rdRecords.cFree6= dispatchLists.cFree6;
            rdRecords.cFree7= dispatchLists.cFree7;
            rdRecords.cFree8= dispatchLists.cFree8;
            rdRecords.cFree9= dispatchLists.cFree9;
            rdRecords.cFree10= dispatchLists.cFree10;
            rdRecords.cGspState = dispatchLists.cGspState;
            //rdRecords.cinva_unit = dispatchLists.cinvde;
            //rdRecords.cInvAddCode= dispatchLists.cinvadd;
            rdRecords.cInvCode = dispatchLists.cInvCode;
            rdRecords.cInvName = dispatchLists.cInvName;
            rdRecords.cInvStd = dispatchLists.cInvStd;
            rdRecords.cInvDefine1 = dispatchLists.cInvDefine1;
            rdRecords.cInvDefine6 = dispatchLists.cInvDefine6;
            rdRecords.cinvm_unit = dispatchLists.cinvm_unit;
            //rdRecords.cInVouchCode = dispatchLists.cinvouch;
            rdRecords.cItem_class = dispatchLists.cItem_class;
            rdRecords.cItemCName = dispatchLists.cItem_CName;
            rdRecords.cItemCode = dispatchLists.cItemCode;
            rdRecords.cMassUnit = dispatchLists.cMassUnit;
            rdRecords.iMassDate= dispatchLists.iMassDate;
            //rdRecords.corufts = dispatchLists.cou;
            //rdRecords.cPosition = dispatchLists.cPosition;
            //rdRecords.cReplaceItem = dispatchLists.crelacusc;
            rdRecords.csocode = dispatchLists.cSoCode;
            //rdRecords.cVenName= dispatchLists.Inventory.cv;
            rdRecords.cvmivencode= dispatchLists.cvmivencode;
            //rdRecords.cvmivenname= dispatchLists.cv;
            //rdRecords.cVouchCode= dispatchLists.cvouc;
            rdRecords.dExpirationdate = dispatchLists.dExpirationdate;
            rdRecords.dMadeDate=  dispatchLists.dMDate;
            rdRecords.dVDate = dispatchLists.dVDate;
            rdRecords.iTaxRate = dispatchLists.iTaxRate;
            //rdRecords.editprop= "A";
            //rdRecords.iAvaNum = dispatchLists.iav;
            //rdRecords.iAvaQuantity = ;
            //rdRecords.iBondedSumQty = ;
            //rdRecords.iCheckIds = ;
            //rdRecords.ID =;
            rdRecords.iDLsID = dispatchLists.iDLsID;
            //rdRecords.iEnsID = dispatchLists.iend;
            rdRecords.iExpiratDateCalcu= dispatchLists.iExpiratDateCalcu;
            //rdRecords.iGrossWeight= dispatchLists.igr;
            rdRecords.iInvExchRate = dispatchLists.iInvExchRate;
            rdRecords.iInvSNCount = dispatchLists.iInvSNCount;
            //rdRecords.iMPoIds = dispatchLists.imoneys;
            //rdRecords.iNetWeight= dispatchLists.inat;
            //rdRecords.iNNum= dispatchLists.innum;
            rdRecords.iNQuantity = dispatchLists.iQuantity-dispatchLists.fOutQuantity;
            rdRecords.iNum = dispatchLists.iNum-dispatchLists.fOutNum;
            rdRecords.iordercode = dispatchLists.cSoCode;
            rdRecords.iorderdid = dispatchLists.iSOsID;
            rdRecords.iorderseq = dispatchLists.iorderrowno;
            //rdRecords.iordertype = dispatchLists.iorer;
            //rdRecords.iPPrice = dispatchLists.ippric;
            //rdRecords.iPresent = dispatchLists.ipr;
            //rdRecords.iPresentNum =;
            //rdRecords.iPrice = dispatchLists.fSalePrice;
            //rdRecords.iPUnitCost= dispatchLists.fSaleCost;
            //rdRecords.iUnitCost = dispatchLists.fSaleCost;
            rdRecords.iQuantity = dispatchLists.iQuantity;
            //rdRecords.iSBsID = dispatchLists.isb;
            //rdRecords.iSendNum = dispatchLists.iNum;
            //rdRecords.iSendQuantity= dispatchLists.iScanQuantity;
            //rdRecords.iSoDID = dispatchLists.iSOsID;
            //rdRecords.isoseq = dispatchLists.irowno;
            //rdRecords.iSoType = dispatchLists.iSettle;
            rdRecords.iSOutNum = dispatchLists.fOutNum;
            rdRecords.iSOutQuantity = dispatchLists.fOutQuantity;
            //rdRecords.iTrIds = dispatchLists.;
            //rdRecords.iVMISettleNum=;
            //rdRecords.iVMISettleQuantity =;
            //rdRecords.scrapufts=;
            //rdRecords.strCode = dispatchLists.str;
            //rdRecords.strContractId =;            

            return rdRecords;
        }

        #endregion
    }
}
