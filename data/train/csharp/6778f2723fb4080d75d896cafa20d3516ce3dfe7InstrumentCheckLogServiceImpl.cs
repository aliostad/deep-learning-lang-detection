using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Global.Common.Models;
using SDataAccess;

namespace SBusiness.MeasureLab
{
    public class InstrumentCheckLogServiceImpl
    {
        public void Save(InstrumentCheckLogModel model)
        {
            if (model.LogId == 0) DataProvider.measureLabInstrumentCheckLogDAO.Add(model);
            else DataProvider.measureLabInstrumentCheckLogDAO.Update(model);
        }

        public IList<InstrumentCheckLogModel> GetByInstrumentId(int instrumentId)
        {
            return DataProvider.measureLabInstrumentCheckLogDAO.GetByInstrumentId(instrumentId);
        }

        public void UpdateIsUseding2False(int logId)
        {
            DataProvider.measureLabInstrumentCheckLogDAO.UpdateIsUseding2False(logId);
        }
        /// <summary>
        /// 删除仪器时，把仪器下的周检记录的IsUseding设为0
        /// </summary>
        /// <param name="itemCode"></param>
        public void UpdateIsUseding2FalseByInstrumentItemCode(string itemCode)
        {
            DataProvider.measureLabInstrumentCheckLogDAO.UpdateIsUseding2FalseByInstrumentItemCode(itemCode);
        }
    }
}
