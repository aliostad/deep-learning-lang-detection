using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GRGT.WCF_Common.WinService.DataAccess;
using GRGT.WCF_Common.WinService.Models;
using GRGTCommonUtils;
using Global.Instrument.Models;

namespace GRGT.WCF_Common.WinService.Business
{
    public class InstrumentServiceImpl
    {

        private static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(InstrumentServiceImpl));

        /// <summary>
        /// 计量仪器管理系统同步仪器数据到各个业务系统
        /// </summary>
        /// <param name="instrumentDataJson"></param>
        /// <param name="businessType"></param>
        /// <returns></returns>
        public string SendInstrumentData(string instrumentDataJson)
        {
            string msg = "Error";
            try
            {
                InstrumentModel model = ToolsLib.Utility.CommonUtils.JsonDeserialize(instrumentDataJson, typeof(InstrumentModel)) as InstrumentModel;
                switch (model.InstrumentCate)
                {
                    case (int)UtilConstants.LabType.MeasureLab:
                        WSProvider.MeasureLabProvider.SendInstrumentData(instrumentDataJson);
                        break;
                    case (int)UtilConstants.LabType.Environment:
                        WSProvider.Environment.SendInstrumentData(instrumentDataJson);
                        break;
                    case (int)UtilConstants.LabType.EMC:
                        //SBusiness.ServiceProvider.emcLabInstrumentService.BeginSynInstrumentData(model);
                        break;
                }
                msg = "OK";
            }
            catch (Exception ex)
            {
                log.Error(ex.ToString());
                msg = ex.Message;
            }

            return msg;
        }

        /// <summary>
        /// 删除仪器管理系统仪器信息时同步删除业务系统中的仪器数据（注：这里只做逻辑删除，将仪器状态改为停用）
        /// </summary>
        /// <param name="itemCode"></param>
        /// <param name="businessType"></param>
        /// <returns></returns>
        public string DeleteInstrumentData(string instrumentJsonData)
        {
            string msg = "Error";
            try
            {
                InstrumentModel model = ToolsLib.Utility.CommonUtils.JsonDeserialize(instrumentJsonData, typeof(InstrumentModel)) as InstrumentModel;
                switch (model.InstrumentCate)
                {
                    case (int)UtilConstants.LabType.MeasureLab:
                        WSProvider.MeasureLabProvider.DeleteInstrumentData(model.ItemCode, (int)UtilConstants.InstrumentState.停用);
                        break;
                    case (int)UtilConstants.LabType.Environment:
                        WSProvider.Environment.DeleteInstrumentData(model.ItemCode, UtilConstants.InstrumentState.停用.GetHashCode());
                        break;
                    case (int)UtilConstants.LabType.EMC:
                        //SBusiness.ServiceProvider.emcLabInstrumentService.UpdateRecordStateByItemCode(model.ItemCode, UtilConstants.InstrumentState.停用.GetHashCode());
                        break;
                }
                msg = "OK";
            }
            catch (Exception ex)
            {
                log.Error(ex.ToString());
                msg = ex.Message;
            }
            return msg;
        }
               

    }
}
