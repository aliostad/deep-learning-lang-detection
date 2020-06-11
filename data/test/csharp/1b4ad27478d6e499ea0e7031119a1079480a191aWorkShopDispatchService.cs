using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TShanTC.Business.QiXiu.IProcesser;
using TShanTC.Business.QiXiu.Model;
using TShanTC.Business.QiXiu.Model.WorkShopDispatch;
using TShanTC.Service.Entity;
using TShanTC.Service.Entity.WorkShopDispatch;

namespace TShanTC.Business.QiXiu.Service
{
    public class WorkShopDispatchService
    {
        private IWorkShopDispatchProcesser _iWorkShopDispatchProcess;
        public WorkShopDispatchService(IWorkShopDispatchProcesser iWorkShopDispatchProcess)
        {
            _iWorkShopDispatchProcess = iWorkShopDispatchProcess;
        }
        /// <summary>
        /// Add or Edit
        /// </summary>
        /// <param name="clientWorkShopDispatch"></param>
        /// <returns></returns>
        public int AddWorkShopDispatch(ClientWorkShopDispatchModel clientWorkShopDispatch)
        {
            if (clientWorkShopDispatch == null)
            {
                return 0;
            }
            var WorkShopDispatchInfo = new WorkShopDispatchEntity()
            {
                ServiceShopId = clientWorkShopDispatch.ServiceShopId,
                ConstructionUnitId = clientWorkShopDispatch.ConstructionUnitId,
                CreateTime = clientWorkShopDispatch.CreateTime,
                Dispatcher = clientWorkShopDispatch.Dispatcher,
                Price = clientWorkShopDispatch.Price,
                ProjectName = clientWorkShopDispatch.ProjectName,
                RepaireCategoryId = clientWorkShopDispatch.RepaireCategoryId,
                ServiceReceptionId = clientWorkShopDispatch.ServiceReceptionId,
                ServiceReceptionTime = clientWorkShopDispatch.ServiceReceptionTime,
                TroubleDesc = clientWorkShopDispatch.TroubleDesc,
                StartTime = clientWorkShopDispatch.StartTime,
                WorkId = clientWorkShopDispatch.WorkId,
                WorkShopDispatchId = clientWorkShopDispatch.WorkShopDispatchId,
                WorkTime = clientWorkShopDispatch.WorkTime,
                Remark = clientWorkShopDispatch.Remark,
            };
            return _iWorkShopDispatchProcess.AddWorkShopDispatch(WorkShopDispatchInfo);
        }
        /// <summary>
        /// 获取仓库列表
        /// </summary>
        /// <param name="clientWorkShopDispatchInfoListRequest"></param>
        /// <returns></returns>
        public QiXiuListResponse<WorkShopDispatchEntity> GetWorkShopDispatchList(ClientWorkShopDispatchListRequest clientWorkShopDispatchListRequest)
        {
            QiXiuListResponse<WorkShopDispatchEntity> WorkShopDispatchList;
            if (clientWorkShopDispatchListRequest == null)
            {
                WorkShopDispatchList = new QiXiuListResponse<WorkShopDispatchEntity>();
            }
            var WorkShopDispatchListRequest = new WorkShopDispatchListRequest()
            {
                StartRowID = clientWorkShopDispatchListRequest.StartRowID,
                EndRowID = clientWorkShopDispatchListRequest.EndRowID,
                ServiceShopId = clientWorkShopDispatchListRequest.ServiceShopId,
                WorkShopDispatchIds = clientWorkShopDispatchListRequest.WorkShopDispatchIds

            };
            return _iWorkShopDispatchProcess.GetWorkShopDispatchList(WorkShopDispatchListRequest);
        }
        /// <summary>
        /// Operate
        /// </summary>
        /// <param name="clientOperateRequest"></param>
        /// <returns></returns>
        public QiXiuOperateResponse WorkShopDispatchOperate(ClientQiXiuOperateRequest clientOperateRequest)
        {
            QiXiuOperateResponse WorkShopDispatchOperate;
            if (clientOperateRequest == null)
            {
                WorkShopDispatchOperate = new QiXiuOperateResponse();
            }
            var operateRequest = new QiXiuOperateRequest()
            {
                OperateParamValue = Convert.ToInt32(clientOperateRequest.OperateParamValue.Split(',')[0]), //todo 要支持一次多个删除
                OperateType = (Operate)clientOperateRequest.OperateType
            };
            return _iWorkShopDispatchProcess.WorkShopDispatchOperate(operateRequest);
        }
    }
}
