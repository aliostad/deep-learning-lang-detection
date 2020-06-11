using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TShanTC.Service.Entity.WorkShopDispatch;

namespace TShanTC.Service.QiXiu.ILogic.WorkShopDispatch
{
    public interface IWorkShopDispatchLogic
    {
        /// <summary>
        /// 添加车间派工
        /// </summary>
        /// <param name="workShopDispatchInfo"></param>
        /// <returns></returns>
        int AddWorkShopDispatch(WorkShopDispatchEntity workShopDispatchInfo);
        /// <summary>
        /// 编辑车间派工
        /// </summary>
        /// <param name="workShopDispatchInfo"></param>
        /// <returns></returns>
        int EditWorkShopDispatch(WorkShopDispatchEntity workShopDispatchInfo);
        /// <summary>
        /// 获取车间派工列表
        /// </summary>
        /// <param name="workShopDispatchListRequest"></param>
        /// <returns></returns>
        List<WorkShopDispatchEntity> GetWorkShopDispatchList(WorkShopDispatchListRequest workShopDispatchListRequest);
        /// <summary>
        /// 删除车间派工
        /// </summary>
        /// <param name="workShopDispatchId"></param>
        /// <returns></returns>
        int DeleteWorkShopDispatch(int workShopDispatchId);
       
    }
}
