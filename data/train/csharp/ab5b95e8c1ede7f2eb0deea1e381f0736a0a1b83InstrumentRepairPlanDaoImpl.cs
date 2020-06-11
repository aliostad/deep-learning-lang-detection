using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Instrument.Common.Models;
using System.Collections;
using ToolsLib.IBatisNet;

namespace Instrument.DataAccess
{

    public class InstrumentRepairPlanDaoImpl
    {
        public void DeleteByInstrumentId(int InstrumentId)
        {
            DBProvider.dbMapper.Delete("Instrument_RepairPlan.DeleteByInstrumentId", InstrumentId);
        }

        /// <summary>
        /// 增加维修计划.
        /// </summary>
        public void Add(InstrumentRepairPlanModel model)
        {
            DBProvider.dbMapper.Insert("Instrument_RepairPlan.Insert", model);
        }

        /// <summary>
        /// 更新维修计划.
        /// </summary>
        public void Update(InstrumentRepairPlanModel model)
        {
            DBProvider.dbMapper.Update("Instrument_RepairPlan.Update", model);
        }

        /// <summary>
        /// 删除维修计划.
        /// </summary>
        public void DeleteById(int PlanId)
        {
            DBProvider.dbMapper.Delete("Instrument_RepairPlan.DeleteById", PlanId);
        }


        /// <summary>
        /// 得到一个维修计划.
        /// </summary>
        public InstrumentRepairPlanModel GetById(int PlanId)
        {
            return DBProvider.dbMapper.SelectObject<InstrumentRepairPlanModel>("Instrument_RepairPlan.GetByID", PlanId);
        }

        /// <summary>
        /// 获得所有记录.
        /// </summary>
        public IList<InstrumentRepairPlanModel> GetAll()
        {
            return DBProvider.dbMapper.SelectList<InstrumentRepairPlanModel>("Instrument_RepairPlan.GetAll");
        }

        /// <summary>
        /// 查询维修计划(根据仪器编号).
        /// </summary>
        public IList<InstrumentRepairPlanModel> GetByInstrumentId(int instrumentId)
        {
            return DBProvider.dbMapper.SelectList<InstrumentRepairPlanModel>("Instrument_RepairPlan.GetByInstrumentId", instrumentId);
        }

        /// <summary>
        /// 查询维修计划.
        /// </summary>
        public IList<InstrumentRepairPlanModel> GetByWhere(string where)
        {
            return DBProvider.dbMapper.SelectList<InstrumentRepairPlanModel>("Instrument_RepairPlan.GetByWhere", where);
        }

        
        /// <summary>
        /// 获取分页数据
        /// </summary>
        /// <param name="paging"></param>
        /// <returns></returns>
        public virtual IList<Hashtable> GetInstrumentRepairPlanForPaging(PagingModel paging)
        {
            paging.TableName = "Instrument_RepairPlan";
            paging.FieldKey = "PlanId";
            if (string.IsNullOrEmpty(paging.FieldOrder))
                paging.FieldOrder = "PlanId desc";
            IList<Hashtable> list = DBProvider.dbMapper.SelectPaginatedList<Hashtable>("Paging.GetListByPaging", paging);
            return list;
        }

    }
}
