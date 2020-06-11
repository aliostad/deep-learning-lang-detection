using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TShanTC.Service.Entity;
using TShanTC.Service.Entity.WorkShopDispatch;
using TShanTC.Service.QiXiu.ILogic.WorkShopDispatch;

namespace TShanTC.Service.Provider.WorkShopDispatch
{
    public class WorkShopDispatchProvider
    {
        IWorkShopDispatchLogic _iWorkShopDispatchLogic;
        public WorkShopDispatchProvider(IWorkShopDispatchLogic iWorkShopDispatchLogic)
        {
            _iWorkShopDispatchLogic = iWorkShopDispatchLogic;
        }
        /// <summary>
        /// 添加车间派工
        /// </summary>
        /// <param name="workShopDispatchInfo"></param>
        /// <returns></returns>
        public int AddWorkShopDispatch(WorkShopDispatchEntity workShopDispatchInfo)
        {
            if (workShopDispatchInfo != null && workShopDispatchInfo.WorkShopDispatchId.HasValue)
            {
                return _iWorkShopDispatchLogic.EditWorkShopDispatch(workShopDispatchInfo);
            }
            else
            {
                return _iWorkShopDispatchLogic.AddWorkShopDispatch(workShopDispatchInfo);
            }

        }
        /// <summary>
        /// 获取车间派工列表
        /// </summary>
        /// <param name="workShopDispatchListRequest"></param>
        /// <returns></returns>
        public QiXiuListResponse<WorkShopDispatchEntity> GetWorkShopDispatchList(WorkShopDispatchListRequest workShopDispatchListRequest)
        {
            QiXiuListResponse<WorkShopDispatchEntity> WorkShopDispatchListResponse = new QiXiuListResponse<WorkShopDispatchEntity>();
            List<WorkShopDispatchEntity> WorkShopDispatchList = _iWorkShopDispatchLogic.GetWorkShopDispatchList(workShopDispatchListRequest);
            WorkShopDispatchListResponse.QiXiuResponseList = WorkShopDispatchList;
            if (WorkShopDispatchList != null && WorkShopDispatchList.Any())
            {
                WorkShopDispatchListResponse.TotalCount = WorkShopDispatchList.FirstOrDefault().TotalCount;
            }
            return WorkShopDispatchListResponse;
        }
        /// <summary>
        /// 车间派工操作
        /// </summary>
        /// <param name="operateRequest"></param>
        /// <returns></returns>
        public QiXiuOperateResponse WorkShopDispatchOperate(QiXiuOperateRequest operateRequest)
        {
            QiXiuOperateResponse operateResponse = new QiXiuOperateResponse();
            if (operateRequest.OperateType == Operate.Delete)
            {
                operateResponse.ResultCode = _iWorkShopDispatchLogic.DeleteWorkShopDispatch(operateRequest.OperateParamValue);
            }
            return operateResponse;

        }
    }
}
