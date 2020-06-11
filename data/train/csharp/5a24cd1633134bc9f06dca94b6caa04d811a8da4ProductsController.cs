using System.Web.Http;
using Microsoft.Web.Http;

namespace ProductService.Controllers
{
    [ApiVersion("1.0")]
    [Route("api/v{version:apiVersion}/products")]
    public class ProductsController: ApiController
    {
        public string Get()
        {
            return "productV1";
        }

    }

    [ApiVersion("2.0")]
    [ApiVersion("3.0")]
    [Route("api/v{version:apiVersion}/products")]
    public class Products2Controller: ApiController
    {
        public string Get()
        {
            return "productV2";
        }

        [MapToApiVersion( "3.0" )]
        public string GetV3()
        {
            return "productV3";
        }
    }

}