using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TShanTC.Authorize.Common;
using TShanTC.Business.QiXiu.Common;
using TShanTC.Business.QiXiu.IProcesser;
using TShanTC.Service.Entity;
using TShanTC.Service.Entity.WorkShopDispatch;

namespace TShanTC.Business.QiXiu.Processer
{
    public class WorkShopDispatchProcesser : IWorkShopDispatchProcesser
    {
        /// <summary>
        /// 添加车间派工
        /// </summary>
        /// <param name="workShopDispatchInfo"></param>
        /// <returns></returns>
        public int AddWorkShopDispatch(WorkShopDispatchEntity workShopDispatchInfo)
        {
            QiXiuHttpPost<int> addWorkShopDispatchResponse = new QiXiuHttpPost<int>();
            var result = addWorkShopDispatchResponse.Execute(workShopDispatchInfo, QiXiuApiUrl.AddWorkShopDispatch);
            return result;
        }
        /// <summary>
        /// 获取车间派工列表
        /// </summary>
        /// <param name="workShopDispatchListRequest"></param>
        /// <returns></returns>
        public QiXiuListResponse<WorkShopDispatchEntity> GetWorkShopDispatchList(WorkShopDispatchListRequest workShopDispatchListRequest)
        {
            QiXiuHttpPost<QiXiuListResponse<WorkShopDispatchEntity>> getWorkShopDispatchListResponse = new QiXiuHttpPost<QiXiuListResponse<WorkShopDispatchEntity>>();
            var result = getWorkShopDispatchListResponse.Execute(workShopDispatchListRequest, QiXiuApiUrl.GetWorkShopDispatchList);
            return result;
        }
        /// <summary>
        /// 车间派工操作
        /// </summary>
        /// <param name="operateRequest"></param>
        /// <returns></returns>
        public QiXiuOperateResponse WorkShopDispatchOperate(QiXiuOperateRequest operateRequest)
        {
            QiXiuHttpPost<QiXiuOperateResponse> WorkShopDispatchOperateResponse = new QiXiuHttpPost<QiXiuOperateResponse>();
            var result = WorkShopDispatchOperateResponse.Execute(operateRequest, QiXiuApiUrl.WorkShopDispatchOperate);
            return result;
        }

    }
}
