using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using TShanTC.Service.Entity;
using TShanTC.Service.Entity.WorkShopDispatch;
using TShanTC.Service.Logic.WorkShopDispatch;
using TShanTC.Service.Provider.WorkShopDispatch;
using TShanTC.Service.QiXiu.Common;
using TShanTC.Service.QiXiu.ILogic.WorkShopDispatch;

namespace TShanTC.Service.QiXiu.Controllers.WorkShopDispatch
{
   
        [RoutePrefix("api/QiXiu/WorkShopDispatch")]
        public class WorkShopDispatchController : ApiController
        {
            /// <summary>
            /// 添加车间派工
            /// </summary>
            /// <param name="soaData"></param>
            /// <returns></returns>
            [HttpPost]
            [Route("AddWorkShopDispatch")]
            public SOAResponseFormat<int> AddWorkShopDispatch([FromBody]SOAData soaData)
            {
                return ApiSOAPerformer.Runing<int, WorkShopDispatchEntity>(soaData, QiXiuProviderLayerIoc<WorkShopDispatchProvider, IWorkShopDispatchLogic, WorkShopDispatchLogic>.ProviderIoc.AddWorkShopDispatch);
            }
            /// <summary>
            /// 获取车间派工列表
            /// </summary>
            /// <param name="soaData"></param>
            /// <returns></returns>
            [HttpPost]
            [Route("GetWorkShopDispatchList")]
            public SOAResponseFormat<QiXiuListResponse<WorkShopDispatchEntity>> GetWorkShopDispatchList([FromBody]SOAData soaData)
            {
                return ApiSOAPerformer.Runing<QiXiuListResponse<WorkShopDispatchEntity>, WorkShopDispatchListRequest>(soaData, QiXiuProviderLayerIoc<WorkShopDispatchProvider, IWorkShopDispatchLogic, WorkShopDispatchLogic>.ProviderIoc.GetWorkShopDispatchList);
            }
            /// <summary>
            /// 车间派工操作
            /// </summary>
            /// <param name="soaData"></param>
            /// <returns></returns>
            [HttpPost]
            [Route("WorkShopDispatchOperate")]
            public SOAResponseFormat<QiXiuOperateResponse> WorkShopDispatchOperate([FromBody]SOAData soaData)
            {
                return ApiSOAPerformer.Runing<QiXiuOperateResponse, QiXiuOperateRequest>(soaData, QiXiuProviderLayerIoc<WorkShopDispatchProvider, IWorkShopDispatchLogic, WorkShopDispatchLogic>.ProviderIoc.WorkShopDispatchOperate);
            }
        }
}
