using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using FlexiCapture.Cloud.Portal.Api.DBHelpers;
using FlexiCapture.Cloud.Portal.Api.Models.OcrApiKeyModels;

namespace FlexiCapture.Cloud.Portal.Api.Controllers
{
    public class OcrApiKeysController : ApiController
    {
        // GET: api/OcrApiKeys
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
        }

        // GET: api/OcrApiKeys/5
        public List<OcrApiKeyModel> Get(int id)
        {
            return OcrApiHelper.GetOcrApiKeys(id);
        }

        // POST: api/OcrApiKeys
        public OcrApiKeyModel Post([FromBody]OcrApiKeyModel model)
        {
            return OcrApiHelper.AddOcrApiKey(model);
        }

        // PUT: api/OcrApiKeys/5
        public OcrApiKeyModel Put([FromBody]OcrApiKeyModel model)
        {
            return OcrApiHelper.UpdateOcrApiKey(model);
        }

        // DELETE: api/OcrApiKeys/5
        public int Delete(int id)
        {
            return OcrApiHelper.DeleteKey(id);
        }
    }
}
