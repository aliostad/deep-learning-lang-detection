using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TShanTC.Service.Entity.WorkShopDispatch;
using TShanTC.Service.QiXiu.ILogic.WorkShopDispatch;

namespace TShanTC.Service.Logic.WorkShopDispatch
{
    public class WorkShopDispatchLogic: IWorkShopDispatchLogic
    {
        /// <summary>
        /// 添加车间派工
        /// </summary>
        /// <param name="workShopDispatchInfo"></param>
        /// <returns></returns>
        public int AddWorkShopDispatch(WorkShopDispatchEntity workShopDispatchInfo)
        {
            return QiXiuDataProcesser.WorkShopDispatch.AddWorkShopDispatch(workShopDispatchInfo);
        }
        /// <summary>
        /// 编辑车间派工
        /// </summary>
        /// <param name="workShopDispatchInfo"></param>
        /// <returns></returns>
        public int EditWorkShopDispatch(WorkShopDispatchEntity workShopDispatchInfo)
        {
            return QiXiuDataProcesser.WorkShopDispatch.EditWorkShopDispatch(workShopDispatchInfo);
        }
        /// <summary>
        /// 获取车间派工列表
        /// </summary>
        /// <param name="workShopDispatchListRequest"></param>
        /// <returns></returns>
        public List<WorkShopDispatchEntity> GetWorkShopDispatchList(WorkShopDispatchListRequest workShopDispatchListRequest)
        {
            return QiXiuDataProcesser.WorkShopDispatch.GetWorkShopDispatchList(workShopDispatchListRequest);
        }
        /// <summary>
        /// 删除车间派工
        /// </summary>
        /// <param name="workShopDispatchId"></param>
        /// <returns></returns>
        public int DeleteWorkShopDispatch(int workShopDispatchId)
        {
            return QiXiuDataProcesser.WorkShopDispatch.DeleteWorkShopDispatch(workShopDispatchId);
        }
    }
}
