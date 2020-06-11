using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Instrument.Common.Models;
using System.Collections;

namespace Instrument.DataAccess
{
    public class InstrumentUsingPlanDaoImpl
    {

        /// <summary>
        /// 增加排期调度.
        /// </summary>
        public void Add(InstrumentUsingPlanModel model)
        {
            DBProvider.dbMapper.Insert("BaseData_InstrumentUsingPlan.Insert", model);
        }

        /// <summary>
        /// 更新排期调度.
        /// </summary>
        public void Update(InstrumentUsingPlanModel model)
        {
            DBProvider.dbMapper.Update("BaseData_InstrumentUsingPlan.Update", model);
        }

        /// <summary>
        /// 删除排期调度.
        /// </summary>
        public void DeleteById(int PlanId)
        {
            DBProvider.dbMapper.Delete("BaseData_InstrumentUsingPlan.DeleteById", PlanId);
        }

        /// <summary>
        /// 得到一个排期调度.
        /// </summary>
        public InstrumentUsingPlanModel GetById(int PlanId)
        {
            return DBProvider.dbMapper.SelectObject<InstrumentUsingPlanModel>("BaseData_InstrumentUsingPlan.GetByID", PlanId);
        }

        /// <summary>
        /// 获得所有排期调度.
        /// </summary>
        public IList<InstrumentUsingPlanModel> GetAll()
        {
            return DBProvider.dbMapper.SelectList<InstrumentUsingPlanModel>("BaseData_InstrumentUsingPlan.GetAll");
        }

        /// <summary>
        /// 查询排期调度(根据仪器标识)
        /// </summary>
        /// <returns></returns>
        public IList<InstrumentUsingPlanModel> GetByInstrumentId(int instrumentId)
        {
            return DBProvider.dbMapper.SelectList<InstrumentUsingPlanModel>("BaseData_InstrumentUsingPlan.GetByInstrumentId", instrumentId);
        }


        /// <summary>
        /// 查询排期(根据仪器标识和时间)
        /// </summary>
        /// <param name="hash"></param>
        /// <returns></returns>
        public IList<InstrumentUsingPlanModel> GetByInstrumentIdsAndDate(Hashtable hash)
        {
            if (hash["InstrumentIdList"]==null)
            {
                return new List<InstrumentUsingPlanModel>();
            }
            return DBProvider.dbMapper.SelectList<InstrumentUsingPlanModel>("BaseData_InstrumentUsingPlan.GetByInstrumentIdsAndDate", hash);
        }

        /// <summary>
        /// 查询排期调度(根据测试项目标识)
        /// </summary>
        /// <returns></returns>
        public IList<InstrumentUsingPlanModel> GetByProjectNumber(string ProjectNumber)
        {
            return DBProvider.dbMapper.SelectList<InstrumentUsingPlanModel>("BaseData_InstrumentUsingPlan.GetByProjectNumber", ProjectNumber);
        }
    }
}
