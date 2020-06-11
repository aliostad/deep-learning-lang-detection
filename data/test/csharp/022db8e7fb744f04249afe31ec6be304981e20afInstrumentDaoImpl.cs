using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ToolsLib.IBatisNet;
using System.Collections;
using Global.Instrument.Models;

namespace Global.Instrument.DataAccess
{
    public class InstrumentDaoImpl
    {
        #region === 接口调用 ===
        public void Add(InstrumentModel model)
        {
            DBProvider.dbMapper.Insert("BaseData_Instrument.Insert", model);
        }

        public void Update(InstrumentModel model)
        {
            DBProvider.dbMapper.Update("BaseData_Instrument.Update", model);
        }

        public InstrumentModel GetByItemCode(string ItemCode)
        {
            return DBProvider.dbMapper.SelectObject<InstrumentModel>("BaseData_Instrument.GetByItemCode", ItemCode);
        }

        public void UpdateRecordStateByItemCode(string itemCode, int recordState)
        {
            Hashtable ht = new Hashtable();
            ht["ItemCode"] = itemCode;
            ht["RecordState"] = recordState;
            DBProvider.dbMapper.Update("BaseData_Instrument.UpdateRecordStateByItemCode", ht);
        }
        #endregion


        #region === 计量、环境和EMC业务系统调用 ===
        /// <summary>
        /// 得到一个对象实体.
        /// </summary>
        public InstrumentModel GetById(int InstrumentId)
        {
            return DBProvider.dbMapper.SelectObject<InstrumentModel>("BaseData_Instrument.GetByID", InstrumentId);
        }

        /// <summary>
        /// 通过ID列表得到对象实体集合.
        /// </summary>
        public IList<InstrumentModel> GetByIds(IList<int> InstrumentIdList)
        {
            if (InstrumentIdList == null || InstrumentIdList.Count == 0) return null;

            return DBProvider.dbMapper.SelectList<InstrumentModel>("BaseData_Instrument.GetListByIds", InstrumentIdList);
        }

        public IList<InstrumentModel> QuickSearchByKeyWord(string input)
        {
            return DBProvider.dbMapper.SelectList<InstrumentModel>("BaseData_Instrument.QuickSearchByKeyWord", input);
        }

        /// <summary>
        /// 根据条件获取设备排期列表记录
        /// </summary>
        /// <param name="hash"></param>
        /// <returns></returns>
        public IList<Hashtable> GetxperimentPlanRecord(Hashtable hash)
        {
            return DBProvider.dbMapper.SelectList<Hashtable>("BaseData_Instrument.GetxperimentPlanRecord", hash);
        }
        /// <summary>
        /// 根据条件获取设备排期列表
        /// </summary>
        /// <param name="hash"></param>
        /// <returns></returns>
        public IList<InstrumentModel> GetExperimentPlanByPage(Hashtable hash)
        {
            return DBProvider.dbMapper.SelectList<InstrumentModel>("BaseData_Instrument.GetExperimentPlanByPage", hash);
        }
        #endregion
    }
}
