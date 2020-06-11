using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GRGTCommonUtils;
using Global.Common.Models;

namespace SBusiness.Common
{
    public class SynInstrumentDataService
    {
        private static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(SynInstrumentDataService));

        ///// <summary>
        ///// 计量仪器管理系统同步仪器数据到各个业务系统
        ///// </summary>
        ///// <param name="instrumentDataJson"></param>
        ///// <param name="businessType"></param>
        ///// <returns></returns>
        //public static string SendInstrumentData(string instrumentDataJson)
        //{
        //    InstrumentModel model = ToolsLib.Utility.CommonUtils.JsonDeserialize(instrumentDataJson, typeof(InstrumentModel)) as InstrumentModel;
        //    try
        //    {
        //        switch (model.BusinessType)
        //        {
        //            case (int)UtilConstants.LabType.MeasureLab:
        //                SBusiness.ServiceProvider.measureLabInstrumentService.BeginSynInstrumentData(model);
        //                break;
        //            case (int)UtilConstants.LabType.Environment:
        //                SBusiness.ServiceProvider.environmentLabInstrumentService.BeginSynInstrumentData(model);
        //                break;
        //            case (int)UtilConstants.LabType.EMC:
        //                SBusiness.ServiceProvider.emcLabInstrumentService.BeginSynInstrumentData(model);
        //                break;
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        log.Error(ex.ToString());
        //        return ex.Message;
        //    }
        //    return "OK";
        //}

        ///// <summary>
        ///// 删除仪器管理系统仪器信息时同步删除业务系统中的仪器数据（注：这里只做逻辑删除，将仪器状态改为停用）
        ///// </summary>
        ///// <param name="itemCode"></param>
        ///// <param name="businessType"></param>
        ///// <returns></returns>
        //public static string DeleteInstrumentData(string instrumentJsonData)
        //{
        //    InstrumentModel model = ToolsLib.Utility.CommonUtils.JsonDeserialize(instrumentJsonData, typeof(InstrumentModel)) as InstrumentModel;
        //    try
        //    {
        //        switch (model.InstrumentType)
        //        {
        //            case (int)UtilConstants.LabType.MeasureLab:
        //                SBusiness.ServiceProvider.measureLabInstrumentService.UpdateRecordStateByItemCode(model.ItemCode, UtilConstants.InstrumentState.停用.GetHashCode());
        //                break;
        //            case (int)UtilConstants.LabType.Environment:
        //                SBusiness.ServiceProvider.environmentLabInstrumentService.UpdateRecordStateByItemCode(model.ItemCode, UtilConstants.InstrumentState.停用.GetHashCode());
        //                break;
        //            case (int)UtilConstants.LabType.EMC:
        //                SBusiness.ServiceProvider.emcLabInstrumentService.UpdateRecordStateByItemCode(model.ItemCode, UtilConstants.InstrumentState.停用.GetHashCode());
        //                break;
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        log.Error(ex.ToString());
        //        return ex.Message;
        //    }
        //    return "OK";
        //}
    }
}
