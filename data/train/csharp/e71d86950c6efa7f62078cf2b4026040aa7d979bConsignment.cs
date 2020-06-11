using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using Model;

namespace DAL
{
    /// <summary>
    /// 销售管理.销售发货
    /// </summary>
    public class Consignment
    {
        /// <summary>
        /// 销售发货:单据装载
        /// </summary>
        /// <param name="connectionString"></param>
        /// <param name="cDLCode"></param>
        /// <param name="errMsg"></param>
        /// <returns></returns>
        /// <remarks>tianzhenyun 2013-06-20</remarks>
        public DispatchList Load(string connectionString, string cDLCode, out string errMsg)
        {
            errMsg = string.Empty;
            DispatchList dispatchList = null;
            //查询主表
            string strSql = string.Format(@" SELECT DISTINCT DispatchList.caddcode, (CASE WHEN isnull(DispatchList.cSBVCode, '') <> '' THEN salebillvouch.cVouchType  ELSE Dispatchlist.cVouchType END) AS cVouchType,  VouchType.cVouchName,
DispatchList.cDLCode,DispatchList.sbvid ,DispatchList.cSBVCode,DispatchList.ddate,DispatchList.cBusType, DispatchList.DLID as DLID,  DispatchList.cSTCode, 
SaleType.cSTName, DispatchList.cCusCode, Customer.cCusAbbName,Customer.cCusName, DispatchList.cDepCode, Department.cDepName,DispatchList.cPersonCode ,
 Person.cPersonName, DispatchList.cMaker,DispatchList.cVerifier,
DispatchList.cShipAddress,convert(char,convert(money,DispatchList.ufts),2) as ufts   ,
DispatchList.cDefine1 , DispatchList.cDefine2, DispatchList.cDefine3, DispatchList.cDefine4, 
 DispatchList.cDefine5, DispatchList.cDefine6, DispatchList.cDefine7, DispatchList.cDefine8, DispatchList.cDefine9, 
 DispatchList.cDefine10, DispatchList.cDefine11, DispatchList.cDefine12, DispatchList.cDefine13, DispatchList.cDefine14,
 DispatchList.cDefine15, DispatchList.cDefine16,DispatchList.cMemo,DispatchList.bReturnFlag 
 from DispatchList inner join   DispatchLists ON DispatchList.DLID = DispatchLists.DLID  
  INNER JOIN  Inventory ON DispatchLists.cInvCode = Inventory.cInvCode left join ComputationUnit on Inventory.ccomunitcode=ComputationUnit.ccomunitcode 
 inner join Warehouse on DispatchLists.cwhcode=warehouse.cwhcode
 LEFT OUTER JOIN SaleType ON DispatchList.cSTCode = SaleType.cSTCode 
 LEFT OUTER JOIN (select cpersoncode as cpersoncode2,cpersonname from Person) person ON DispatchList.cPersonCode = Person.cPersonCode2 
 LEFT OUTER JOIN  Customer ON DispatchList.cCusCode = Customer.cCusCode 
 LEFT OUTER JOIN Department ON DispatchList.cDepCode = Department.cDepCode
 left join SaleBillVouch on SaleBillVouch.SBVID = dbo.DispatchList.SBVID  
 left join VouchType on VouchType.cVouchType = case when  salebillvouch.SBVID is null then dispatchlist.cVouchType else salebillvouch.cVouchType end  
 WHERE  (DispatchList.cVouchType='05' OR DispatchList.cVouchType='06') 
AND  ((ISNULL(DispatchList.cSaleOut,'') = '' OR isnull(bqaneedcheck,0)=1) OR DispatchList.cSaleOut ='ST')    
AND NOT (isnull(DispatchList.bFirst,0) =1 And isnull(DispatchLists.bIsStQC,0) =0) 
AND (
	(ABS(ISNULL((case when (isnull(DispatchLists.bQANeedCheck,0)=1 and DispatchLists.iquantity>0) then DispatchLists.iqaquantity else DispatchLists.iquantity end ),0))-ABS(ISNULL(DispatchLists.fOutQuantity,0))    ) >=0.01 
	or ( igrouptype=2 and  (  ABS(ISNULL((case when (isnull(DispatchLists.bQANeedCheck,0)=1 and DispatchLists.iquantity>0) then DispatchLists.iqanum else DispatchLists.inum end ),0))-ABS(ISNULL(DispatchLists.fOutnum,0)) ) >=0.01)
	)
AND (ISNULL(DispatchLists.cWhCode,'')<>'') 
AND bInvType=0 
AND bService=0  
AND	((ISNULL(DispatchLists.bSettleAll,0)=0 and DispatchList.cvouchtype='05') or DispatchList.cvouchtype='06')  
AND ISNULL(DispatchList.cVerifier,'')<>''  
AND DISPATCHLIST.CDLCODE = N'{0}'
AND (
	(case when isnull(DispatchLists.bQANeedCheck,0)=1 and isnull(DispatchLists.iquantity,0)>0 then DispatchLists.iqaquantity else DispatchLists.iquantity end) <>0 
	 OR (case when isnull(DispatchLists.bQANeedCheck,0)=1  and isnull(DispatchLists.inum,0)>0 then DispatchLists.iqanum else DispatchLists.inum end) <>0)", cDLCode);

            DataTable dt = null;
            try
            {
                dt = DBHelperSQL.QueryTable(connectionString, strSql);
            }
            catch (Exception ex)
            {
                errMsg = ex.Message;
                return dispatchList;
            }
            if (dt.Rows.Count == 0)
            {
                errMsg = "单据错误或单据不存在、未审核、已关闭";
                return dispatchList;
            }
            //转换主表
            dispatchList = EntityConvert.ConvertToDispatchList(dt.Rows[0]);
            //查询子表
            strSql = string.Format(@"Select WareHouse.cWhName
,DispatchList.cDLCode
,DispatchLists.AutoID,DispatchLists.cWhCode, DispatchLists.DLID, DispatchLists.iCorID,DispatchLists.cInvCode,DispatchLists.iQuotedPrice,DispatchLists.ccusinvcode,DispatchLists.ccusinvname,DispatchLists.iExpiratDateCalcu,DispatchLists.cExpirationdate,DispatchLists.dExpirationdate,DispatchLists.iUnitPrice, DispatchLists.iTaxUnitPrice,DispatchLists.iMoney, DispatchLists.iTax, DispatchLists.iDisCount,DispatchLists.iSum, DispatchLists.iNatUnitPrice,DispatchLists.iNatMoney, DispatchLists.iNatTax, DispatchLists.iNatSum,DispatchLists.iNatDisCount, DispatchLists.iSettleNum,DispatchLists.iSettleQuantity, DispatchLists.iBatch,DispatchLists.iInvExchRate,DispatchLists.cBatch, DispatchLists.bSettleAll, DispatchLists.cvmivencode,DispatchLists.cFree1, DispatchLists.cFree2, DispatchLists.iTB,DispatchLists.dMDate , DispatchLists.dvDate,DispatchLists.cMassUnit,DispatchLists.iMassDate, DispatchLists.TBQuantity, DispatchLists.TBNum,DispatchLists.iSOsID, DispatchLists.iDLsID, DispatchLists.KL,DispatchLists.iTaxRate, DispatchLists.KL2,DispatchLists.cDefine22, DispatchLists.cDefine23,DispatchLists.cDefine24, DispatchLists.cDefine25,DispatchLists.cDefine26, DispatchLists.cDefine27,convert(int,1) as isotype, DispatchLists.isosid as isodid,DispatchLists.idemandtype,DispatchLists.cdemandcode,DispatchLists.cdemandid,DispatchLists.idemandseq,DispatchLists.cItemCode, DispatchLists.cItem_class,DispatchLists.fSaleCost, DispatchLists.fSalePrice,DispatchLists.cVenAbbName, DispatchLists.cItemName,DispatchLists.cContractid,DispatchLists.ccontractTagCode,DispatchLists.ccontractrowguid,DispatchLists.cItem_CName, DispatchLists.cFree3,DispatchLists.cFree4, DispatchLists.cFree5, DispatchLists.cFree6,DispatchLists.cFree7, DispatchLists.cFree8, DispatchLists.cFree9,DispatchLists.cFree10,DispatchLists.cBatchProperty1,DispatchLists.cBatchProperty2,DispatchLists.cBatchProperty3, DispatchLists.bIsSTQc,DispatchLists.cBatchProperty4,DispatchLists.cBatchProperty5,DispatchLists.cBatchProperty6,DispatchLists.cBatchProperty7,DispatchLists.cBatchProperty8,DispatchLists.cBatchProperty9,DispatchLists.cBatchProperty10,DispatchLists.cUnitID, DispatchLists.cCode,DispatchLists.iRetQuantity, DispatchLists.fEnSettleQuan,DispatchLists.fEnSettleSum, DispatchLists.iSettlePrice,DispatchLists.cDefine28, DispatchLists.cDefine29,DispatchLists.cDefine30, DispatchLists.cDefine31,DispatchLists.cDefine32, DispatchLists.cDefine33,DispatchLists.cDefine34, DispatchLists.cDefine35,DispatchLists.cDefine36, DispatchLists.cDefine37,DispatchLists.bGsp, DispatchLists.cGspState,DispatchLists.bQANeedCheck,DispatchLists.cSoCode,DispatchLists.bCosting,DispatchLists.iorderrowno
,v1.cvenabbname as cvmivenname
,ComputationUnit.cComUnitName AS cinvm_unit,ComputationUnit_1.cComUnitName AS cinva_unit 
,SaleType.cstcode,saletype.cstname, SA_SORowNo.iRowNo
,inventory.cinvaddcode,Inventory.cInvName,Inventory.cInvStd, Inventory.cInvCCode, Inventory.cVenCode, Inventory.cReplaceItem, Inventory.cPosition, Inventory.bSale,Inventory.bPurchase, Inventory.bSelf, Inventory.bComsume,Inventory.bProducing, Inventory.bService, Inventory.bAccessary,Inventory.iInvWeight, Inventory.iVolume,Inventory.iInvRCost, Inventory.iInvSPrice, Inventory.iInvSCost,Inventory.iInvLSCost, Inventory.iInvNCost, Inventory.iInvAdvance,Inventory.iInvBatch, Inventory.iSafeNum, Inventory.iTopSum,Inventory.iLowSum, Inventory.iOverStock, Inventory.cInvABC,Inventory.bInvQuality, Inventory.bInvBatch, Inventory.bInvEntrust,Inventory.bInvOverStock, Inventory.dSDate, Inventory.dEDate,Inventory.bFree1, Inventory.bFree2, Inventory.cInvDefine1,Inventory.cInvDefine2, Inventory.cInvDefine3, Inventory.I_id,Inventory.bInvType, Inventory.iInvMPCost, Inventory.cQuality,Inventory.iInvSaleCost, Inventory.iInvSCost1, Inventory.iInvSCost2,Inventory.iInvSCost3, Inventory.bFree3, Inventory.bFree4,Inventory.bFree5, Inventory.bFree6, Inventory.bFree7,Inventory.bFree8, Inventory.bFree9, Inventory.bFree10,Inventory.cCreatePerson, Inventory.cModifyPerson,Inventory.dModifyDate, Inventory.fSubscribePoint,Inventory.fVagQuantity, Inventory.cValueType, Inventory.bFixExch,Inventory.fOutExcess, Inventory.fInExcess,Inventory.iWarnDays, Inventory.fExpensesExch, Inventory.bTrack,Inventory.bSerial, Inventory.bBarCode, Inventory.iId,Inventory.cBarCode, Inventory.cInvDefine4, Inventory.cInvDefine5,Inventory.cInvDefine6, Inventory.cInvDefine7, Inventory.cInvDefine8,Inventory.cInvDefine9, Inventory.cInvDefine10, Inventory.cInvDefine11,Inventory.cInvDefine12, Inventory.cInvDefine13, Inventory.cInvDefine14,Inventory.cInvDefine15, Inventory.cInvDefine16,convert(bit,0) AS bQuanSign, Inventory.iGroupType,Inventory.cGroupCode, Inventory.cAssComUnitCode,Inventory.cSAComUnitCode, Inventory.cPUComUnitCode,Inventory.cSTComUnitCode, Inventory.cComUnitCode,Inventory.cCAComUnitCode, Inventory.cFrequency, Inventory.iFrequency,Inventory.iDays, Inventory.dLastDate, Inventory.iWastage,Inventory.bSolitude, Inventory.cEnterprise, Inventory.cAddress,Inventory.cFile, Inventory.cLabel, Inventory.cCheckOut,Inventory.cLicence, Inventory.bSpecialties, Inventory.cDefWareHouse, Inventory.iHighPrice, Inventory.cPriceGroup,Inventory.iExpSaleRate, Inventory.cOfferGrade, Inventory.iOfferRate,Inventory.cMonth, Inventory.iAdvanceDate, Inventory.cCurrencyName,Inventory.cProduceAddress, Inventory.cProduceNation,Inventory.cRegisterNo, Inventory.cEnterNo, Inventory.cPackingType,Inventory.cEnglishName, Inventory.bPropertyCheck,Inventory.cPreparationType, Inventory.cCommodity,Inventory.iRecipeBatch, Inventory.cNotPatentName,Inventory.pubufts
,(case when (isnull(DispatchLists.bQANeedCheck,0)=1 and DispatchLists.iquantity>0) then isnull(DispatchLists.iqaquantity,0) else isnull(DispatchLists.iquantity,0) end ) as iquantity
, (case when (isnull(DispatchLists.bqaneedcheck,0)=1 and DispatchLists.inum>0) then isnull(DispatchLists.iqanum,0) else isnull(DispatchLists.inum,0) end) as inum,isnull(DispatchLists.fOutQuantity,0) as fOutQuantity
,isnull(case when inventory.igrouptype=1 then DispatchLists.fOutQuantity/DispatchLists.iInvExchRate else DispatchLists.fOutNum end ,0) as fOutNum 
 From dbo.DispatchList  
 INNER JOIN DispatchLists ON DispatchList.DLID = DispatchLists.DLID 
 INNER JOIN Inventory ON DispatchLists.cInvCode = Inventory.cInvCode 
 INNER JOIN Warehouse ON DispatchLists.cWhCode = Warehouse.cWhCode 
 INNER JOIN ComputationUnit ON Inventory.cComUnitCode = ComputationUnit.cComunitCode 
 LEFT OUTER JOIN Department ON DispatchList.cDepCode = Department.cDepCode 
 LEFT OUTER JOIN ComputationUnit ComputationUnit_1 ON DispatchLists.cUnitID = ComputationUnit_1.cComunitCode 
 Left Join SA_SORowNo On Dispatchlists.isosid=SA_SORowNo.isosid 
 Left Join SaleType ON DispatchList.cStCode=SaleType.cstcode 
 left join vendor v1 on v1.cvencode =dispatchlists.cvmivencode 
 left join (select cpersoncode as cpersoncode2,cpersonname from person) person on person.cpersoncode2 =dispatchlist.cpersoncode  
 left join  SaleBillVouch on SaleBillVouch.SBVID = DispatchList.SBVID 
 left join VouchType on VouchType.cVouchType = case when  salebillvouch.SBVID is null then dispatchlist.cVouchType else salebillvouch.cVouchType end  
 WHERE  (DispatchList.cVouchType='05' OR DispatchList.cVouchType='06')  
 AND  ((ISNULL(DispatchList.cSaleOut,'') = '' OR isnull(bqaneedcheck,0)=1) OR DispatchList.cSaleOut ='ST')    
 AND not (isnull(DispatchList.bFirst,0) =1 And isnull(DispatchLists.bIsStQC,0) =0) 
 and (
	(ABS(ISNULL((case when (isnull(DispatchLists.bQANeedCheck,0)=1 and DispatchLists.iquantity>0) then DispatchLists.iqaquantity else DispatchLists.iquantity end ),0))-ABS(ISNULL(DispatchLists.fOutQuantity,0))    ) >=0.01 
	or ( igrouptype=2 and  (  ABS(ISNULL((case when (isnull(DispatchLists.bQANeedCheck,0)=1 and DispatchLists.iquantity>0) then DispatchLists.iqanum else DispatchLists.inum end ),0))-ABS(ISNULL(DispatchLists.fOutnum,0)) ) >=0.01)
	)
 AND (ISNULL(DispatchLists.cWhCode,'')<>'') 
 AND bInvType=0 
 AND bService=0  
 AND ((ISNULL(DispatchLists.bSettleAll,0)=0 and DispatchList.cvouchtype='05') or DispatchList.cvouchtype='06')  
and  ISNULL(DispatchList.cVerifier,'')<>''  
AND	DISPATCHLIST.CDLCODE = N'{0}' 
and	((case when isnull(DispatchLists.bQANeedCheck,0)=1 and isnull(DispatchLists.iquantity,0)>0 then DispatchLists.iqaquantity else DispatchLists.iquantity end) <>0  OR (case when isnull(DispatchLists.bQANeedCheck,0)=1  and isnull(DispatchLists.inum,0)>0 then DispatchLists.iqanum else DispatchLists.inum end) <>0) ", cDLCode);

            try
            {
                dt = DBHelperSQL.QueryTable(connectionString, strSql);
            }
            catch (Exception ex)
            {
                errMsg = ex.Message;
                return dispatchList;
            }
            //转换子表
            DispatchLists dispatchLists = null;
            foreach (DataRow row in dt.Rows)
            {
                dispatchLists = EntityConvert.ConvertToDispatchLists(row);
                dispatchList.List.Add(dispatchLists);
            }

            return dispatchList;
        }
    }
}
