using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Instrument.Common.Models;
using System.Collections;

namespace Instrument.DataAccess
{
    public class InstrumentCheckLogDaoImpl
    {
        public void DeleteByInstrumentId(int InstrumentId)
        {
            DBProvider.dbMapper.Delete("Instrument_CheckLog.DeleteByInstrumentId", InstrumentId);
        }
        /// <summary>
        /// 增加周检记录.
        /// </summary>
        public void Add(InstrumentCheckLogModel model)
        {
            DBProvider.dbMapper.Insert("Instrument_CheckLog.Insert", model);
        }

        /// <summary>
        /// 更新周检记录.
        /// </summary>
        public void Update(InstrumentCheckLogModel model)
        {
            DBProvider.dbMapper.Update("Instrument_CheckLog.Update", model);
        }

        ///// <summary>
        ///// 更新周检记录(完成).
        ///// </summary>
        //public void UpdateForComplete(int LogId)
        //{
        //    DBProvider.dbMapper.Update("Instrument_CheckLog.UpdateForComplete", LogId);
        //}

        /// <summary>
        /// 删除周检记录.
        /// </summary>
        public void DeleteById(int LogId)
        {
            DBProvider.dbMapper.Delete("Instrument_CheckLog.DeleteById", LogId);
        }


        /// <summary>
        /// 得到一个周检记录.
        /// </summary>
        public InstrumentCheckLogModel GetById(int LogId)
        {
            return DBProvider.dbMapper.SelectObject<InstrumentCheckLogModel>("Instrument_CheckLog.GetByID", LogId);
        }

        /// <summary>
        /// 获得所有周检记录.
        /// </summary>
        public IList<InstrumentCheckLogModel> GetAll()
        {
            return DBProvider.dbMapper.SelectList<InstrumentCheckLogModel>("Instrument_CheckLog.GetAll");
        }

        public IList<Hashtable> GetByInstrumentBarCode(string barCode)
        {
            return DBProvider.dbMapper.SelectList<Hashtable>("Instrument_CheckLog.GetByInstrumentBarCode", barCode);
        }

        public IList<Hashtable> GetByInstrumentId(int instrumentId)
        {
            return DBProvider.dbMapper.SelectList<Hashtable>("Instrument_CheckLog.GetByInstrumentId", instrumentId);
        }

        /// <summary>
        /// 查询周检记录.
        /// </summary>
        public IList<Hashtable> GetInstrumentCheckLogListByWhere(string where)
        {
            return DBProvider.dbMapper.SelectList<Hashtable>("Instrument_CheckLog.GetInstrumentCheckLogListByWhere", where);
        }

    }
}
