using System.Collections.Generic;
using System.Web.Http;
using ApiGeneratorApi.Generator;
using ApiGeneratorApi.Models;

namespace ApiGeneratorApi.Controllers
{
    public class GeneratorController : ApiController
    {
        [HttpGet]
        public IHttpActionResult Index()
        {
            return Ok();
        }

        [HttpPost]
        public IHttpActionResult Generate(ApiSpecification apiSpecification)
        {
            //var endpoints = new List<EndpointSpec>();

            //foreach (var endpoint in apiSpecification.Endpoints)
            //{
            //    new EndPointGenerator(endpoint).Generate();
            //    endpoints.Add(endpoint);
            //}

            //new WebApiGenerator(endpoints).Generate();

            return Ok(apiSpecification);
        }
    }
}