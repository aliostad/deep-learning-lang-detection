using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ToolsLib.IBatisNet;
using System.Collections;
using Lab.EMC.Common.Models;

namespace Lab.EMC.DataAccess
{
    public class OrderProjectDispatchDaoImpl
    {
        /// <summary>
        /// 增加一条数据.
        /// </summary>
        public void Add(OrderProjectDispatchModel model)
        {
            DBProvider.dbMapper.Insert("Order_ProjectDispatch.Insert", model);
        }

        /// <summary>
        /// 更新一条数据.
        /// </summary>
        public void Update(OrderProjectDispatchModel model)
        {
            DBProvider.dbMapper.Update("Order_ProjectDispatch.Update", model);
        }

        /// <summary>
        /// 删除一条数据.
        /// </summary>
        public void DeleteById(int DispatchId)
        {
            DBProvider.dbMapper.Delete("Order_ProjectDispatch.DeleteById", DispatchId);
        }


        /// <summary>
        /// 得到一个对象实体.
        /// </summary>
        public OrderProjectDispatchModel GetById(int DispatchId)
        {
            return DBProvider.dbMapper.SelectObject<OrderProjectDispatchModel>("Order_ProjectDispatch.GetByID", DispatchId);
        }

        /// <summary>
        /// 获得所有记录.
        /// </summary>
        public IList<OrderProjectDispatchModel> GetAll()
        {
            return DBProvider.dbMapper.SelectList<OrderProjectDispatchModel>("Order_ProjectDispatch.GetAll");
        }

        public void UpdateRecordState(OrderProjectDispatchModel model)
        {
            DBProvider.dbMapper.Update("Order_ProjectDispatch.UpdateRecordState", model);
        }

        public IList<OrderProjectDispatchModel> GetDispatchInfo(string dispatchIds)
        {
            return DBProvider.dbMapper.SelectList<OrderProjectDispatchModel>("Order_ProjectDispatch.GetDispatchInfo", dispatchIds);
        }

        public IList<OrderProjectDispatchModel> GetByOrderId(int OrderId)
        {
            return DBProvider.dbMapper.SelectList<OrderProjectDispatchModel>("Order_ProjectDispatch.GetByOrderId", OrderId);
        }
    }
}
