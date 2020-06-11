using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Instrument.Common.Models;
using Instrument.DataAccess;
using System.Collections;
using GRGTCommonUtils;

namespace Instrument.Business
{
    public class InstrumentCheckLogServiceImpl
    {

        public void DeleteByInstrumentId(int InstrumentId)
        {
            DBProvider.InstrumentCheckLogDAO.DeleteByInstrumentId(InstrumentId);
        }

        /// <summary>
        /// 删除记录.
        /// </summary>
        public void DeleteById(int LogId)
        {
            DBProvider.InstrumentCheckLogDAO.DeleteById(LogId);
        }

        ///// <summary>
        ///// 更新周检记录(完成).
        ///// </summary>
        //public void UpdateForComplete(int LogId)
        //{
        //    DBProvider.InstrumentCheckLogDAO.UpdateForComplete(LogId);
        //}

        ///// <summary>
        ///// 保存实体数据.
        ///// </summary>
        //public void Save(InstrumentCheckLogModel model,InstrumentModel instrument)
        //{
        //    model.InstrumentId = instrument.InstrumentId;
        //    model.CheckUser = LoginHelper.LoginUser.UserName;
        //    model.CheckDate = DateTime.Now;
        //    if (model.CheckLogId == 0)
        //    {
        //        DBProvider.InstrumentCheckLogDAO.Add(model);
        //    }
        //    else
        //    {
        //        DBProvider.InstrumentCheckLogDAO.Update(model);
        //    }
        //    //更新资产最后盘点记录
        //    instrument.LastCheckDate = model.CheckDate;
        //    instrument.LastCheckUser = model.CheckUser;
        //    DBProvider.InstrumentDAO.UpdateAssetsCheckResult(instrument);
        //}

        /// <summary>
        /// 获取一个记录对象.
        /// </summary>
        public InstrumentCheckLogModel GetById(int LogId)
        {
            return DBProvider.InstrumentCheckLogDAO.GetById(LogId);
        }

        /// <summary>
        /// 获取所有周检记录.
        /// </summary>
        public IList<InstrumentCheckLogModel> GetAll()
        {
            return DBProvider.InstrumentCheckLogDAO.GetAll();
        }
        /// <summary>
        /// 根据固定资产BarCode查询盘点记录
        /// </summary>
        /// <param name="barCode"></param>
        /// <returns></returns>
        public IList<Hashtable> GetByInstrumentBarCode(string barCode)
        {
            return DBProvider.InstrumentCheckLogDAO.GetByInstrumentBarCode(barCode);
        }

        public IList<Hashtable> GetByInstrumentId(int instrumentId)
        {
            return DBProvider.InstrumentCheckLogDAO.GetByInstrumentId(instrumentId);
        }

        /// <summary>
        /// 查询周检记录.
        /// </summary>
        public IList<Hashtable> GetInstrumentCheckLogListByWhere(string where)
        {
            return DBProvider.InstrumentCheckLogDAO.GetInstrumentCheckLogListByWhere(where);
        }

    }
}
