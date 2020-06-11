using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using ToolsLib.IBatisNet;
using Global.Common.Models;
using Lab.Environment.Common.Models;
using Lab.Environment.DataAccess;
using GRGTCommonUtils;
using Lab.Environment.Common;
using LightFlow.Common.Models;

namespace Lab.Environment.Business
{
    public class OrderProjectDispatchDetailServiceImpl
    {
        /// <summary>
		/// 删除记录.
		/// </summary>
        public void DeleteById(int DetailId)
		{
            DBProvider.OrderProjectDispatchDetailDao.DeleteById(DetailId);
		}

		/// <summary>
		/// 保存实体数据.
		/// </summary>
		public void Save(OrderProjectDispatchDetailModel model)
		{
            if (model.DetailId == 0) DBProvider.OrderProjectDispatchDetailDao.Add(model);
            else DBProvider.OrderProjectDispatchDetailDao.Update(model);
		}

		/// <summary>
		/// 获取一个记录对象.
		/// </summary>
        public OrderProjectDispatchDetailModel GetById(int DetailId)
		{
            return DBProvider.OrderProjectDispatchDetailDao.GetById(DetailId);
		}

		/// <summary>
		/// 获取所有的记录对象.
		/// </summary>
		public IList<OrderProjectDispatchDetailModel> GetAll()
		{
            return DBProvider.OrderProjectDispatchDetailDao.GetAll();
		}

        /// <summary>
        /// 
        /// </summary>
        public IList<OrderProjectDispatchDetailModel> GetByDispatchId(int DispatchId)
        {
            return DBProvider.OrderProjectDispatchDetailDao.GetByDispatchId(DispatchId);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="DispatchId"></param>
        /// <returns></returns>
        public int GetCountByDispatchId(int DispatchId)
        {
            return DBProvider.OrderProjectDispatchDetailDao.GetCountByDispatchId(DispatchId);
        }
    }
}
