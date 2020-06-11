using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ToolsLib.IBatisNet;
using Instrument.Common.Models;
using System.Collections;

namespace Instrument.DataAccess
{
    public class InstrumentCertificationDaoImpl
    {

        public void DeleteByInstrumentId(int InstrumentId)
        {
            DBProvider.dbMapper.Delete("Instrument_Certification.DeleteByInstrumentId", InstrumentId);
        }

        /// <summary>
        /// 增加一条数据.
        /// </summary>
        public void Add(InstrumentCertificationModel model)
        {
            DBProvider.dbMapper.Insert("Instrument_Certification.Insert", model);
        }

        /// <summary>
        /// 更新一条数据.
        /// </summary>
        public void Update(InstrumentCertificationModel model)
        {
            DBProvider.dbMapper.Update("Instrument_Certification.Update", model);
        }

        public void UpdateFileIdByInstrumentIdAndOrderNo(int instrumentId, int fileId, string orderNo)
        {
            Hashtable ht = new Hashtable();
            ht["InstrumentId"] =instrumentId;
            ht["FileId"] =fileId;
            ht["OrderNo"] = orderNo;
            DBProvider.dbMapper.Update("Instrument_Certification.UpdateFileIdByInstrumentIdAndOrderNo", ht);
        }

        public void UpdateCertInfo(InstrumentCertificationModel model)
        {
            DBProvider.dbMapper.Update("Instrument_Certification.UpdateCertInfo", model);
        }

        public void UpdateIsUseding(InstrumentCertificationModel model)
        {
            DBProvider.dbMapper.Update("Instrument_Certification.UpdateIsUseding", model);
        }
        
        /// <summary>
        /// 删除一条数据.
        /// </summary>
        public void DeleteById(int LogId)
        {
            DBProvider.dbMapper.Delete("Instrument_Certification.DeleteById", LogId);
        }


        /// <summary>
        /// 得到一个对象实体.
        /// </summary>
        public InstrumentCertificationModel GetById(int LogId)
        {
            return DBProvider.dbMapper.SelectObject<InstrumentCertificationModel>("Instrument_Certification.GetByID", LogId);
        }

        /// <summary>
        /// 根据证书编号查找证书信息
        /// </summary>
        /// <param name="certificationCode"></param>
        /// <returns></returns>
        public InstrumentCertificationModel GetByCertificationCode(string certificationCode)
        {
            return DBProvider.dbMapper.SelectObject<InstrumentCertificationModel>("Instrument_Certification.GetByCertificationCode", certificationCode);
        }

        /// <summary>
        /// 根据证书编号查找证书信息
        /// </summary>
        /// <param name="certificationCode"></param>
        /// <returns></returns>
        public IList<InstrumentCertificationModel> GetListByCertificationCode(string certificationCode)
        {
            return DBProvider.dbMapper.SelectList<InstrumentCertificationModel>("Instrument_Certification.GetByCertificationCode", certificationCode);
        }

        /// <summary>
        /// 是否存在证书编号
        /// </summary>
        /// <param name="certificationCode"></param>
        /// <returns></returns>
        public bool IsExistCertificationCode(int logId, string certificationCode)
        {
            InstrumentCertificationModel model = new InstrumentCertificationModel();
            model.LogId = logId;
            model.CertificationCode = certificationCode;
            int count = DBProvider.dbMapper.SelectObject<int>("Instrument_Certification.IsExistCertificationCode", model);
            return count > 0;
        }

        /// <summary>
        /// 获取仪器下最大的到期日期证书
        /// </summary>
        public virtual InstrumentCertificationModel GetMaxEndDateByInstrumentId(int instrumentId, string currentDate)
        {
            Hashtable ht = new Hashtable();
            ht["InstrumentId"] = instrumentId;
            ht["CurrentDate"] = currentDate;
            return DBProvider.dbMapper.SelectObject<InstrumentCertificationModel>("Instrument_Certification.GetMaxEndDateByInstrumentId", ht);
        }


        public IList<InstrumentCertificationModel> GetByInstrumentId(int instrumentId)
        {
            return DBProvider.dbMapper.SelectList<InstrumentCertificationModel>("Instrument_Certification.GetByInstrumentId", instrumentId);
        }

        /// <summary>
        /// 获得所有记录.
        /// </summary>
        public IList<InstrumentCertificationModel> GetAll()
        {
            return DBProvider.dbMapper.SelectList<InstrumentCertificationModel>("Instrument_Certification.GetAll");
        }

        public virtual IList<Hashtable> GetInstrumentCertificationListForPaging(PagingModel paging)
        {
            paging.TableName = "Instrument_Certification";
            paging.FieldKey = "InstrumentId";
            if (string.IsNullOrEmpty(paging.FieldOrder))
                paging.FieldOrder = "InstrumentId desc";
            IList<Hashtable> list = DBProvider.dbMapper.SelectPaginatedList<Hashtable>("Paging.GetListByPaging", paging);
            return list;
        }
        /// <summary>
        /// 更新证书文件
        /// </summary>
        /// <param name="model"></param>
        public void UpdateCertFile(InstrumentCertificationModel model)
        {
            DBProvider.dbMapper.Update("Instrument_Certification.UpdateCertFile", model);
        }

        /// <summary>
        /// 获得记录.
        /// </summary>
        public IList<InstrumentCertificationModel> GetByWhere(string where)
        {
            return DBProvider.dbMapper.SelectList<InstrumentCertificationModel>("Instrument_Certification.GetByWhere", where);
        }

        /// <summary>
        /// 通过ID列表得到对象实体集合.
        /// </summary>
        public IList<InstrumentCertificationModel> GetByIds(IList<int> instrumentIdList)
        {
            Hashtable ht = new Hashtable();
            if (instrumentIdList == null || instrumentIdList.Count == 0)
                instrumentIdList = new List<int>() { 0 };
            ht.Add("InstrumentIdList", instrumentIdList);
            return DBProvider.dbMapper.SelectList<InstrumentCertificationModel>("Instrument_Certification.GetByInstrumentIDList", ht);
        }
    }
}
