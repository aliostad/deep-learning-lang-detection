using System.IO;
using Common.Logging;
using Dispatch.Core;
using Nancy;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace Dispatch.Boundary
{
    public class DispatchRequestModule : NancyModule
    {
        private static readonly ILog Log = LogManager.GetCurrentClassLogger();
        public DispatchRequestModule(DispatchApplicationService svc)
        {
            Post["/dispatch-order"] = x =>
            {
                using (var sr = new StreamReader(Request.Body))
                {
                    var content = sr.ReadToEnd();

                    var jo = JObject.Parse(content);

                    //if (jo["metadata"]["command"].Value<string>() == "dispatch-order")
                    {
                        Log.Info("Got a request");
                        var order = new OrderInfo(jo["data"].ToString(Formatting.Indented));
                        var command = new DispatchOrderCommand(order);
                        svc.Handle(command);
                    }
                }

                return HttpStatusCode.Accepted;
            };
        }
    }

    
}