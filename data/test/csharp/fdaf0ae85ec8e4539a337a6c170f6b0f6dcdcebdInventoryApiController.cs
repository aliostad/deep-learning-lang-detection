using System.Web.Http;
using ZM.SignalR.Integrations.WebApiMvc.Infrastructure.Communication.Hubs;
using ZM.SignalR.Integrations.WebApiMvc.Infrastructure.WebApi;
using ZM.SignalR.Integrations.WebApiMvc.Models;

namespace ZM.SignalR.Integrations.WebApiMvc.Controllers.WebApi
{
    [RoutePrefix("api/inventory")]
    public class InventoryApiController : BaseWebApiHubController<ConnectionBroadcaster>
    {
        /// <summary>
        /// Retrieves an API by unique identifier.
        /// </summary>
        /// <param name="apiId">The unique identifier of an API to retrieve.</param>
        /// <returns>
        /// If found, returns a successful response to a consumer which includes a materialized
        /// API, otherwise returns an unsucessful response to a consumer with a message.
        /// </returns>
        /// <example>GET api/apis/get-api/12345</example>
        [HttpGet]
        [Route("get-api/{apiId}")]
        public IHttpActionResult ApiSearch(ApiRequest apiRequest)
        {
            if (apiRequest == null || apiRequest.ApiId < 1 || apiRequest.ApiId > 10000)
            {
                return BadRequest();
            }

            if (apiRequest.ApiId != 10000)
            {
                return NotFound();
            }

            var apiId = apiRequest.ApiId;

            var api = new Api()
            {
                Id = apiId,
                Name = "Some-Awesome-Api-Name",
                Description = "Some awesome API with a cool name that retrieves neat stuff for you based on your request.",
                Version = "1.0"
            };

            var apiResponse = new ApiResponse() { Api = api };

            return Ok<ApiResponse>(apiResponse);
        }
    }
}