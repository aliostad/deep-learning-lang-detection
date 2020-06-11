using System;
using System.Collections.Generic;
using System.Web.Http;
using RoleAuthorize.Api;

namespace SampleWebApplication.Controllers
{
    [RoleAuthorize(RoleNames = "Admin")]
    public class TestController : ApiController
    {
        // GET: api/Api
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
        }

        // GET: api/Api/5
        public string Get(int id)
        {
            return "value";
        }

        // POST: api/Api
        public void Post([FromBody]string value)
        {
        }

        // PUT: api/Api/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE: api/Api/5
        public void Delete(int id)
        {
        }
    }
}