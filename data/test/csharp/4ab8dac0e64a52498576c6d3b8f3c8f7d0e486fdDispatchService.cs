using SYFY.IT.DAL;
using SYFY.IT.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SYFY.IT.BLL
{
    public class DispatchService
    {
        DispatchDal dal = new DispatchDal();
        /// <summary>
        /// 添加，连带添加产品
        /// </summary>
        /// <param name="dispatchEntity">派工单主表</param>
        /// <param name="lstMorningShif">早班派工产品</param>
        /// <param name="lstMiddleShift">中班派工产品</param>
        /// <param name="lstNightShift">晚班派工产品</param>
        /// <returns></returns>
        public int AddAndProduct(Dispatch dispatchEntity, List<DispatchProduct> lstMorningShif, List<DispatchProduct> lstMiddleShift, List<DispatchProduct> lstNightShift)
        {
            return dal.AddAndProduct(dispatchEntity, lstMorningShif, lstMiddleShift, lstNightShift);
        }
    }
}
