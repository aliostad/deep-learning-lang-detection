using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Http;
using System.Web.Http.Description;
using System.Collections.ObjectModel;

using MSGorilla.Filters;

namespace MSGorilla.Controllers
{
    public class DocumentController : Controller
    {
        //
        // GET: /Document/
        [TokenAuthAttribute]
        public ActionResult Index()
        {
            IApiExplorer apiExplorer = GlobalConfiguration.Configuration.Services.GetApiExplorer();
            //Collection<ApiDescription> apiDescriptions = apiExplorer.ApiDescriptions;
            //foreach (ApiDescription api in apiDescriptions)
            //{
            //    //api.
            //}



            //return View(apiExplorer);
            return View(GetAllAPI());
        }

        private Dictionary<string, List<ApiDescription>> GetAllAPI()
        {
            Dictionary<string, List<ApiDescription>> dict = new Dictionary<string, List<ApiDescription>>();
            dict["api/base"] = FindControllerApi("api/base");
            dict["api/account"] = FindControllerApi("api/account");
            dict["api/attachment"] = FindControllerApi("api/attachment");
            dict["api/message"] = FindControllerApi("api/message");
            dict["api/reply"] = FindControllerApi("api/reply");
            dict["api/topic"] = FindControllerApi("api/topic");
            dict["api/group"] = FindControllerApi("api/group");
            dict["api/metricchart"] = FindControllerApi("api/metricchart");
            //dict["api/schema"] = FindControllerApi("api/schema");

            return dict;
        }
        private List<ApiDescription> FindControllerApi(string routeStart)
        {
            IApiExplorer apiExplorer = GlobalConfiguration.Configuration.Services.GetApiExplorer();
            Dictionary<string, List<ApiDescription>> apis = new Dictionary<string, List<ApiDescription>>();

            List<ApiDescription> list = new List<ApiDescription>();
            foreach(var api in apiExplorer.ApiDescriptions)
            {
                if (api.RelativePath.StartsWith(routeStart, StringComparison.InvariantCultureIgnoreCase))
                {
                    list.Add(api);
                }
            }
            return list;
        }
	}
}