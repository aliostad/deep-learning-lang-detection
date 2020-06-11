using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using RWPLEntityModel;
using RWPLEntityModel.PageDataRequest;
using RWPLEntityModel.SearchRequest;
using RWPLLinqDataService;

namespace RWPLWebApiService.Controllers
{
    public class DispatchController : ApiController
    {
        // GET api/dispatch/getPageData
        [ActionName("GetPageData")]
        [HttpGet]
        public ResultResponse<DispatchReportPageRequest> GetPageData()
        {
            throw new Exception();
            //return DispatchDataService.GetPageData();
        }

        // GET api/dispatch/get
        [ActionName("Get")]
        [HttpPost]
        public ResultResponse<Dispatch> PostGet(DispatchSearchRequest request)
        {
            throw new Exception();
            //return DispatchDataService.Get(request);
        }

        

        // GET api/dispatch/5
        public string Get(int id)
        {
            return "value";
        }

        // POST api/dispatch
        public void Post([FromBody]string value)
        {
        }

        // PUT api/dispatch/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE api/dispatch/5
        public void Delete(int id)
        {
        }
    }
}
