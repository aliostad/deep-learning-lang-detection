using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ToolsLib.IBatisNet;
using Global.Common.Models;
using System.Collections;

namespace Global.DataAccess
{
    public class InstrumentAttachmentDaoImpl
    {
        /// <summary>
        /// 增加一条数据.
        /// </summary>
        public void Add(InstrumentAttachmentModel model)
        {
            DBProvider.dbMapper.Insert("BaseData_InstrumentAttachment.Insert", model);
        }

        /// <summary>
        /// 更新一条数据.
        /// </summary>
        public void Update(InstrumentAttachmentModel model)
        {
            DBProvider.dbMapper.Update("BaseData_InstrumentAttachment.Update", model);
        }

        /// <summary>
        /// 删除一条数据.
        /// </summary>
        public void DeleteByPk(InstrumentAttachmentModel model)
        {
            DBProvider.dbMapper.Delete("BaseData_InstrumentAttachment.DeleteByPk", model);
        }


        /// <summary>
        /// 得到一个对象实体.
        /// </summary>
        public InstrumentAttachmentModel GetByPk(InstrumentAttachmentModel model)
        {
            return DBProvider.dbMapper.SelectObject<InstrumentAttachmentModel>("BaseData_InstrumentAttachment.GetByPk", model);
        }

        /// <summary>
        /// 获得所有记录.
        /// </summary>
        public IList<InstrumentAttachmentModel> GetAll()
        {
            return DBProvider.dbMapper.SelectList<InstrumentAttachmentModel>("BaseData_InstrumentAttachment.GetAll");
        }

        /// <summary>
        /// 获取指定器具的附件信息
        /// </summary>
        /// <param name="instrumentId">器具Id</param>
        /// <returns></returns>
        public IList<InstrumentAttachmentModel> GetByInstrumentId(int instrumentId)
        {
            return DBProvider.dbMapper.SelectList<InstrumentAttachmentModel>("BaseData_InstrumentAttachment.GetByInstrumentId", instrumentId);
        }
    }
}
