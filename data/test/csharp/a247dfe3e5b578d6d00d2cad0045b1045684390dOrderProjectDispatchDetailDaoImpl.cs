using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ToolsLib.IBatisNet;
using System.Collections;
using Lab.EMC.Common.Models;

namespace Lab.EMC.DataAccess
{
    public class OrderProjectDispatchDetailDaoImpl
    {
        /// <summary>
		/// 增加一条数据.
		/// </summary>
		public void Add(OrderProjectDispatchDetailModel model)
		{
			DBProvider.dbMapper.Insert("Order_ProjectDispatchDetail.Insert", model);
		}

		/// <summary>
		/// 更新一条数据.
		/// </summary>
		public void Update(OrderProjectDispatchDetailModel model)
		{
			DBProvider.dbMapper.Update("Order_ProjectDispatchDetail.Update", model);
		}

		/// <summary>
		/// 删除一条数据.
		/// </summary>
        public void DeleteById(int DetailId)
		{
            DBProvider.dbMapper.Delete("Order_ProjectDispatchDetail.DeleteById", DetailId);
		}


		/// <summary>
		/// 得到一个对象实体.
		/// </summary>
        public OrderProjectDispatchDetailModel GetById(int DetailId)
		{
            return DBProvider.dbMapper.SelectObject<OrderProjectDispatchDetailModel>("Order_ProjectDispatchDetail.GetByID", DetailId);
		}

		/// <summary>
		/// 获得所有记录.
		/// </summary>
		public IList<OrderProjectDispatchDetailModel> GetAll()
		{
			return DBProvider.dbMapper.SelectList<OrderProjectDispatchDetailModel>("Order_ProjectDispatchDetail.GetAll");
		}

        /// <summary>
        /// .
        /// </summary>
        public IList<OrderProjectDispatchDetailModel> GetByDispatchId(int DispatchId)
        {
            return DBProvider.dbMapper.SelectList<OrderProjectDispatchDetailModel>("Order_ProjectDispatchDetail.GetByDispatchId", DispatchId);
        }
    }
}
