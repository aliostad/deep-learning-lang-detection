using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TShanTC.Service.Entity;
using TShanTC.Service.Entity.WorkShopDispatch;

namespace TShanTC.Business.QiXiu.IProcesser
{
  public  interface IWorkShopDispatchProcesser
    {
        /// <summary>
        /// 添加车间派工
        /// </summary>
        /// <param name="workShopDispatchInfo"></param>
        /// <returns></returns>
         int AddWorkShopDispatch(WorkShopDispatchEntity workShopDispatchInfo) ;
        /// <summary>
        /// 获取车间派工列表
        /// </summary>
        /// <param name="workShopDispatchListRequest"></param>
        /// <returns></returns>
        QiXiuListResponse<WorkShopDispatchEntity> GetWorkShopDispatchList(WorkShopDispatchListRequest workShopDispatchListRequest);

        /// <summary>
        /// 车间派工操作
        /// </summary>
        /// <param name="operateRequest"></param>
        /// <returns></returns>
         QiXiuOperateResponse WorkShopDispatchOperate(QiXiuOperateRequest operateRequest);
       
    }
}
