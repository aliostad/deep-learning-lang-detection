using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Instrument.DataAccess;
using System.Collections;
using ToolsLib.IBatisNet;
using Instrument.Common;
using Instrument.Common.Models;
using GRGTCommonUtils;
using System.Data;
using Global.Common.Models;

namespace Instrument.Business
{
    public class InstrumentFlowServiceImpl
    {
        /// <summary>
        /// 删除记录.
        /// </summary>
        public void DeleteById(int FlowId)
        {
            DBProvider.InstrumentFlowDao.DeleteById(FlowId);
        }

        /// <summary>
        /// 保存实体数据.
        /// </summary>
        public void Save(InstrumentFlowModel model)
        {
            if (model.FlowId == 0) DBProvider.InstrumentFlowDao.Add(model);
            else DBProvider.InstrumentFlowDao.Update(model);
        }

        /// <summary>
        /// 获取一个记录对象.
        /// </summary>
        public InstrumentFlowModel GetById(int FlowId)
        {
            return DBProvider.InstrumentFlowDao.GetById(FlowId);
        }

        /// <summary>
        /// 获取所有的记录对象.
        /// </summary>
        public IList<InstrumentFlowModel> GetAll()
        {
            return DBProvider.InstrumentFlowDao.GetAll();
        }

        public IList<InstrumentFlowModel> GetByInstrumentId(int instrumentId)
        {
            return DBProvider.InstrumentFlowDao.GetByInstrumentId(instrumentId);
        }
        
    }
}
