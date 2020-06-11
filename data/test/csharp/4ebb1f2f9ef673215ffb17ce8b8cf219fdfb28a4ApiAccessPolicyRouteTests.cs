// ReSharper disable All
using System;
using System.Configuration;
using System.Diagnostics;
using System.Net.Http;
using System.Runtime.Caching;
using System.Web.Http;
using System.Web.Http.Controllers;
using System.Web.Http.Dispatcher;
using System.Web.Http.Hosting;
using System.Web.Http.Routing;
using Xunit;

namespace MixERP.Net.Api.Policy.Tests
{
    public class ApiAccessPolicyRouteTests
    {
        [Theory]
        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy/delete/{apiAccessPolicyId}", "DELETE", typeof(ApiAccessPolicyController), "Delete")]
        [InlineData("/api/policy/api-access-policy/delete/{apiAccessPolicyId}", "DELETE", typeof(ApiAccessPolicyController), "Delete")]
        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy/edit/{apiAccessPolicyId}", "PUT", typeof(ApiAccessPolicyController), "Edit")]
        [InlineData("/api/policy/api-access-policy/edit/{apiAccessPolicyId}", "PUT", typeof(ApiAccessPolicyController), "Edit")]
        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy/count-where", "POST", typeof(ApiAccessPolicyController), "CountWhere")]
        [InlineData("/api/policy/api-access-policy/count-where", "POST", typeof(ApiAccessPolicyController), "CountWhere")]
        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy/get-where/{pageNumber}", "POST", typeof(ApiAccessPolicyController), "GetWhere")]
        [InlineData("/api/policy/api-access-policy/get-where/{pageNumber}", "POST", typeof(ApiAccessPolicyController), "GetWhere")]
        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy/add-or-edit", "POST", typeof(ApiAccessPolicyController), "AddOrEdit")]
        [InlineData("/api/policy/api-access-policy/add-or-edit", "POST", typeof(ApiAccessPolicyController), "AddOrEdit")]
        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy/add/{apiAccessPolicy}", "POST", typeof(ApiAccessPolicyController), "Add")]
        [InlineData("/api/policy/api-access-policy/add/{apiAccessPolicy}", "POST", typeof(ApiAccessPolicyController), "Add")]
        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy/bulk-import", "POST", typeof(ApiAccessPolicyController), "BulkImport")]
        [InlineData("/api/policy/api-access-policy/bulk-import", "POST", typeof(ApiAccessPolicyController), "BulkImport")]
        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy/meta", "GET", typeof(ApiAccessPolicyController), "GetEntityView")]
        [InlineData("/api/policy/api-access-policy/meta", "GET", typeof(ApiAccessPolicyController), "GetEntityView")]
        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy/count", "GET", typeof(ApiAccessPolicyController), "Count")]
        [InlineData("/api/policy/api-access-policy/count", "GET", typeof(ApiAccessPolicyController), "Count")]
        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy/all", "GET", typeof(ApiAccessPolicyController), "GetAll")]
        [InlineData("/api/policy/api-access-policy/all", "GET", typeof(ApiAccessPolicyController), "GetAll")]
        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy/export", "GET", typeof(ApiAccessPolicyController), "Export")]
        [InlineData("/api/policy/api-access-policy/export", "GET", typeof(ApiAccessPolicyController), "Export")]
        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy/1", "GET", typeof(ApiAccessPolicyController), "Get")]
        [InlineData("/api/policy/api-access-policy/1", "GET", typeof(ApiAccessPolicyController), "Get")]
        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy/get?apiAccessPolicyIds=1", "GET", typeof(ApiAccessPolicyController), "Get")]
        [InlineData("/api/policy/api-access-policy/get?apiAccessPolicyIds=1", "GET", typeof(ApiAccessPolicyController), "Get")]
        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy", "GET", typeof(ApiAccessPolicyController), "GetPaginatedResult")]
        [InlineData("/api/policy/api-access-policy", "GET", typeof(ApiAccessPolicyController), "GetPaginatedResult")]
        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy/page/1", "GET", typeof(ApiAccessPolicyController), "GetPaginatedResult")]
        [InlineData("/api/policy/api-access-policy/page/1", "GET", typeof(ApiAccessPolicyController), "GetPaginatedResult")]
        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy/count-filtered/{filterName}", "GET", typeof(ApiAccessPolicyController), "CountFiltered")]
        [InlineData("/api/policy/api-access-policy/count-filtered/{filterName}", "GET", typeof(ApiAccessPolicyController), "CountFiltered")]
        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy/get-filtered/{pageNumber}/{filterName}", "GET", typeof(ApiAccessPolicyController), "GetFiltered")]
        [InlineData("/api/policy/api-access-policy/get-filtered/{pageNumber}/{filterName}", "GET", typeof(ApiAccessPolicyController), "GetFiltered")]
        [InlineData("/api/policy/api-access-policy/first", "GET", typeof(ApiAccessPolicyController), "GetFirst")]
        [InlineData("/api/policy/api-access-policy/previous/1", "GET", typeof(ApiAccessPolicyController), "GetPrevious")]
        [InlineData("/api/policy/api-access-policy/next/1", "GET", typeof(ApiAccessPolicyController), "GetNext")]
        [InlineData("/api/policy/api-access-policy/last", "GET", typeof(ApiAccessPolicyController), "GetLast")]

        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy/custom-fields", "GET", typeof(ApiAccessPolicyController), "GetCustomFields")]
        [InlineData("/api/policy/api-access-policy/custom-fields", "GET", typeof(ApiAccessPolicyController), "GetCustomFields")]
        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy/custom-fields/{resourceId}", "GET", typeof(ApiAccessPolicyController), "GetCustomFields")]
        [InlineData("/api/policy/api-access-policy/custom-fields/{resourceId}", "GET", typeof(ApiAccessPolicyController), "GetCustomFields")]
        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy/meta", "HEAD", typeof(ApiAccessPolicyController), "GetEntityView")]
        [InlineData("/api/policy/api-access-policy/meta", "HEAD", typeof(ApiAccessPolicyController), "GetEntityView")]
        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy/count", "HEAD", typeof(ApiAccessPolicyController), "Count")]
        [InlineData("/api/policy/api-access-policy/count", "HEAD", typeof(ApiAccessPolicyController), "Count")]
        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy/all", "HEAD", typeof(ApiAccessPolicyController), "GetAll")]
        [InlineData("/api/policy/api-access-policy/all", "HEAD", typeof(ApiAccessPolicyController), "GetAll")]
        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy/export", "HEAD", typeof(ApiAccessPolicyController), "Export")]
        [InlineData("/api/policy/api-access-policy/export", "HEAD", typeof(ApiAccessPolicyController), "Export")]
        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy/1", "HEAD", typeof(ApiAccessPolicyController), "Get")]
        [InlineData("/api/policy/api-access-policy/1", "HEAD", typeof(ApiAccessPolicyController), "Get")]
        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy/get?apiAccessPolicyIds=1", "HEAD", typeof(ApiAccessPolicyController), "Get")]
        [InlineData("/api/policy/api-access-policy/get?apiAccessPolicyIds=1", "HEAD", typeof(ApiAccessPolicyController), "Get")]
        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy", "HEAD", typeof(ApiAccessPolicyController), "GetPaginatedResult")]
        [InlineData("/api/policy/api-access-policy", "HEAD", typeof(ApiAccessPolicyController), "GetPaginatedResult")]
        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy/page/1", "HEAD", typeof(ApiAccessPolicyController), "GetPaginatedResult")]
        [InlineData("/api/policy/api-access-policy/page/1", "HEAD", typeof(ApiAccessPolicyController), "GetPaginatedResult")]
        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy/count-filtered/{filterName}", "HEAD", typeof(ApiAccessPolicyController), "CountFiltered")]
        [InlineData("/api/policy/api-access-policy/count-filtered/{filterName}", "HEAD", typeof(ApiAccessPolicyController), "CountFiltered")]
        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy/get-filtered/{pageNumber}/{filterName}", "HEAD", typeof(ApiAccessPolicyController), "GetFiltered")]
        [InlineData("/api/policy/api-access-policy/get-filtered/{pageNumber}/{filterName}", "HEAD", typeof(ApiAccessPolicyController), "GetFiltered")]
        [InlineData("/api/policy/api-access-policy/first", "HEAD", typeof(ApiAccessPolicyController), "GetFirst")]
        [InlineData("/api/policy/api-access-policy/previous/1", "HEAD", typeof(ApiAccessPolicyController), "GetPrevious")]
        [InlineData("/api/policy/api-access-policy/next/1", "HEAD", typeof(ApiAccessPolicyController), "GetNext")]
        [InlineData("/api/policy/api-access-policy/last", "HEAD", typeof(ApiAccessPolicyController), "GetLast")]

        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy/custom-fields", "HEAD", typeof(ApiAccessPolicyController), "GetCustomFields")]
        [InlineData("/api/policy/api-access-policy/custom-fields", "HEAD", typeof(ApiAccessPolicyController), "GetCustomFields")]
        [InlineData("/api/{apiVersionNumber}/policy/api-access-policy/custom-fields/{resourceId}", "HEAD", typeof(ApiAccessPolicyController), "GetCustomFields")]
        [InlineData("/api/policy/api-access-policy/custom-fields/{resourceId}", "HEAD", typeof(ApiAccessPolicyController), "GetCustomFields")]

        [Conditional("Debug")]
        public void TestRoute(string url, string verb, Type type, string actionName)
        {
            //Arrange
            url = url.Replace("{apiVersionNumber}", this.ApiVersionNumber);
            url = Host + url;

            //Act
            HttpRequestMessage request = new HttpRequestMessage(new HttpMethod(verb), url);

            IHttpControllerSelector controller = this.GetControllerSelector();
            IHttpActionSelector action = this.GetActionSelector();

            IHttpRouteData route = this.Config.Routes.GetRouteData(request);
            request.Properties[HttpPropertyKeys.HttpRouteDataKey] = route;
            request.Properties[HttpPropertyKeys.HttpConfigurationKey] = this.Config;

            HttpControllerDescriptor controllerDescriptor = controller.SelectController(request);

            HttpControllerContext context = new HttpControllerContext(this.Config, route, request)
            {
                ControllerDescriptor = controllerDescriptor
            };

            var actionDescriptor = action.SelectAction(context);

            //Assert
            Assert.NotNull(controllerDescriptor);
            Assert.NotNull(actionDescriptor);
            Assert.Equal(type, controllerDescriptor.ControllerType);
            Assert.Equal(actionName, actionDescriptor.ActionName);
        }

        #region Fixture
        private readonly HttpConfiguration Config;
        private readonly string Host;
        private readonly string ApiVersionNumber;

        public ApiAccessPolicyRouteTests()
        {
            this.Host = ConfigurationManager.AppSettings["HostPrefix"];
            this.ApiVersionNumber = ConfigurationManager.AppSettings["ApiVersionNumber"];
            this.Config = GetConfig();
        }

        private HttpConfiguration GetConfig()
        {
            if (MemoryCache.Default["Config"] == null)
            {
                HttpConfiguration config = new HttpConfiguration();
                config.MapHttpAttributeRoutes();
                config.Routes.MapHttpRoute("VersionedApi", "api/" + this.ApiVersionNumber + "/{schema}/{controller}/{action}/{id}", new { id = RouteParameter.Optional });
                config.Routes.MapHttpRoute("DefaultApi", "api/{schema}/{controller}/{action}/{id}", new { id = RouteParameter.Optional });

                config.EnsureInitialized();
                MemoryCache.Default["Config"] = config;
                return config;
            }

            return MemoryCache.Default["Config"] as HttpConfiguration;
        }

        private IHttpControllerSelector GetControllerSelector()
        {
            if (MemoryCache.Default["ControllerSelector"] == null)
            {
                IHttpControllerSelector selector = this.Config.Services.GetHttpControllerSelector();
                return selector;
            }

            return MemoryCache.Default["ControllerSelector"] as IHttpControllerSelector;
        }

        private IHttpActionSelector GetActionSelector()
        {
            if (MemoryCache.Default["ActionSelector"] == null)
            {
                IHttpActionSelector selector = this.Config.Services.GetActionSelector();
                return selector;
            }

            return MemoryCache.Default["ActionSelector"] as IHttpActionSelector;
        }
        #endregion
    }
}