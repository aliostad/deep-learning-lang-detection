using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Global.Common.Models;
using System.Collections;

namespace Global.DataAccess
{
    public class InstrumentCertificationDaoImpl
    {

        /// <summary>
        /// 增加周检记录.
        /// </summary>
        public void Add(InstrumentCertificationModel model)
        {
            DBProvider.dbMapper.Insert("BaseData_InstrumentCertification.Insert", model);
        }

        /// <summary>
        /// 更新周检记录.
        /// </summary>
        public void Update(InstrumentCertificationModel model)
        {
            DBProvider.dbMapper.Update("BaseData_InstrumentCertification.Update", model);
        }

        ///// <summary>
        ///// 更新周检记录(完成).
        ///// </summary>
        //public void UpdateForComplete(int LogId)
        //{
        //    DBProvider.dbMapper.Update("BaseData_InstrumentCertification.UpdateForComplete", LogId);
        //}

        /// <summary>
        /// 删除周检记录.
        /// </summary>
        public void DeleteById(int LogId)
        {
            DBProvider.dbMapper.Delete("BaseData_InstrumentCertification.DeleteById", LogId);
        }


        /// <summary>
        /// 得到一个周检记录.
        /// </summary>
        public InstrumentCertificationModel GetById(int LogId)
        {
            return DBProvider.dbMapper.SelectObject<InstrumentCertificationModel>("BaseData_InstrumentCertification.GetByID", LogId);
        }

        /// <summary>
        /// 获得所有周检记录.
        /// </summary>
        public IList<InstrumentCertificationModel> GetAll()
        {
            return DBProvider.dbMapper.SelectList<InstrumentCertificationModel>("BaseData_InstrumentCertification.GetAll");
        }

        /// <summary>
        /// 查询周检记录(根据仪器编号).
        /// </summary>
        public IList<InstrumentCertificationModel> GetByInstrumentId(int instrumentId)
        {
            return DBProvider.dbMapper.SelectList<InstrumentCertificationModel>("BaseData_InstrumentCertification.GetByInstrumentId", instrumentId);
        }

        /// <summary>
        /// 查询周检记录.
        /// </summary>
        public IList<Hashtable> GetInstrumentCertificationListByWhere(string where)
        {
            return DBProvider.dbMapper.SelectList<Hashtable>("BaseData_InstrumentCertification.GetInstrumentCertificationListByWhere", where);
        }

    }
}
