using KayakoRestApi.Net;
using System.Net;

namespace KayakoRestApi.Controllers
{
    public class BaseController
    {
        internal IKayakoApiRequest Connector { get; set;}

        internal BaseController(string apiKey, string secretKey, string apiUrl, IWebProxy proxy)
        {
            Connector = new KayakoApiRequest(apiKey, secretKey, apiUrl, proxy, ApiRequestType.QueryString);
        }

		internal BaseController(string apiKey, string secretKey, string apiUrl, IWebProxy proxy, ApiRequestType requestType)
		{
			Connector = new KayakoApiRequest(apiKey, secretKey, apiUrl, proxy, requestType);
		}

		internal BaseController(IKayakoApiRequest kayakoApiRequest)
		{
			Connector = kayakoApiRequest;
		}
    }
}
