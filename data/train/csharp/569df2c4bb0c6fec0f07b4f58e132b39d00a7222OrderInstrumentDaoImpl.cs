using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using CustomerPortal.Common.Models;
using System.Collections;

namespace CustomerPortal.DataAccess
{
    public class OrderInstrumentDaoImpl
    {
        /// <summary>
        /// 保存实体数据.
        /// </summary>
        public void Save(OrderInstrumentModel model)
        {
            if (model.InstrumentId == 0) Add(model);
            else Update(model);
        }

        /// <summary>
        /// 增加一条数据.
        /// </summary>
        public void Add(OrderInstrumentModel model)
        {
            DBProvider.dbMapper.Insert("Order_Instrument.Insert", model);
        }

        /// <summary>
        /// 更新一条数据.
        /// </summary>
        public void Update(OrderInstrumentModel model)
        {
            DBProvider.dbMapper.Update("Order_Instrument.Update", model);
        }

        ///// <summary>
        ///// 删除一条数据.
        ///// </summary>
        //public void DeleteById(int InstrumentId)
        //{
        //    DBProvider.dbMapper.Delete("Order_Instrument.DeleteById", InstrumentId);
        //}


        ///// <summary>
        ///// 得到一个对象实体.
        ///// </summary>
        //public OrderInstrumentModel GetById(int InstrumentId)
        //{
        //    return DBProvider.dbMapper.SelectObject<OrderInstrumentModel>("Order_Instrument.GetByID", InstrumentId);
        //}

        //public IList<OrderInstrumentModel> GetByOrderId(int orderId)
        //{
        //    return DBProvider.dbMapper.SelectList<OrderInstrumentModel>("Order_Instrument.GetByOrderId", orderId);
        //}

        //public IList<OrderInstrumentModel> GetByOrderIdList(IList<int> orderIdList)
        //{
        //    if (orderIdList == null || orderIdList.Count < 0)
        //    {
        //        return new List<OrderInstrumentModel>();
        //    }
        //    return DBProvider.dbMapper.SelectList<OrderInstrumentModel>("Order_Instrument.GetByOrderIdList", orderIdList);
        //}

        ///// <summary>
        ///// 获得所有记录.
        ///// </summary>
        //public IList<OrderInstrumentModel> GetAll()
        //{
        //    return DBProvider.dbMapper.SelectList<OrderInstrumentModel>("Order_Instrument.GetAll");
        //}

    }
}
