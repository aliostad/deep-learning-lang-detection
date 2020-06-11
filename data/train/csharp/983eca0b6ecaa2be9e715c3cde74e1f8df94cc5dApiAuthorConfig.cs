using System.Web;
using System.Web.Http;

namespace ApiAuthor.Example.App_Start
{
    public static class ApiAuthorConfig
    {
        public static void Configure(HttpConfiguration config)
        {
            var apiExplorer = config.Services.GetApiExplorer();
            var xmlDocumentation = HttpContext.Current.Server.MapPath("~/bin/ApiAuthor.Example.XML");

            ApiAuthorFactory.Configure(apiExplorer, xmlDocumentation, apiAuthorFactory =>
            {
                apiAuthorFactory.ApiVersion = "1.0";
            });
        }
    }
}
