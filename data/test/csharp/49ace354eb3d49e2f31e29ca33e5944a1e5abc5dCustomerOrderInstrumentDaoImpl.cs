using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Measure.LabCommon.Models;
using System.Collections;

namespace Measure.LabDataAccess
{
    public class CustomerOrderInstrumentDaoImpl
    {

        /// <summary>
        /// 增加一条数据.
        /// </summary>
        public void Add(CustomerOrderInstrumentModel model)
        {
            DBProvider2.customerDbMapper.Insert("CustomerOrder_Instrument.Insert", model);
        }

        /// <summary>
        /// 更新一条数据.
        /// </summary>
        public void Update(CustomerOrderInstrumentModel model)
        {
            DBProvider2.customerDbMapper.Update("CustomerOrder_Instrument.Update", model);
        }

        /// <summary>
        /// 删除一条数据.
        /// </summary>
        public void DeleteById(int InstrumentId)
        {
            DBProvider2.customerDbMapper.Delete("CustomerOrder_Instrument.DeleteById", InstrumentId);
        }


        /// <summary>
        /// 得到一个对象实体.
        /// </summary>
        public CustomerOrderInstrumentModel GetById(int InstrumentId)
        {
            return DBProvider2.customerDbMapper.SelectObject<CustomerOrderInstrumentModel>("CustomerOrder_Instrument.GetByID", InstrumentId);
        }

        public IList<CustomerOrderInstrumentModel> GetByOrderId(int orderId)
        {
            return DBProvider2.customerDbMapper.SelectList<CustomerOrderInstrumentModel>("CustomerOrder_Instrument.GetByOrderId", orderId);
        }

        public IList<CustomerOrderInstrumentModel> GetByOrderIdList(IList<int> orderIdList)
        {
            if (orderIdList == null || orderIdList.Count < 0)
            {
                return new List<CustomerOrderInstrumentModel>();
            }
            return DBProvider2.customerDbMapper.SelectList<CustomerOrderInstrumentModel>("CustomerOrder_Instrument.GetByOrderIdList", orderIdList);
        }

        /// <summary>
        /// 获得所有记录.
        /// </summary>
        public IList<CustomerOrderInstrumentModel> GetAll()
        {
            return DBProvider2.customerDbMapper.SelectList<CustomerOrderInstrumentModel>("CustomerOrder_Instrument.GetAll");
        }

    }
}
