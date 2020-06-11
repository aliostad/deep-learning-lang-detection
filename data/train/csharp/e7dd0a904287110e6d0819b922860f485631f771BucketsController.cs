using System.Linq;
using System.Web.Http;
using Statr.Api;

namespace Statr.Web.Controllers.api
{
    public class BucketsController : ApiController
    {
        private readonly IStatrApi api;

        public BucketsController(IStatrApi api)
        {
            this.api = api;
        }

        public dynamic Get()
        {
            return new
            {
                buckets = api.Buckets()
            };
        }

        public dynamic Get(string id)
        {
            var bucket = api.Buckets().Single(b => b.Name == id);

            return new
            {
                bucket
            };
        }
    }
}