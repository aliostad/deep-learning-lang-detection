using ZendeskApi_v2;
using System.Configuration;

namespace Common
{
    public class ZendeskApiManager
    {
        private static string apiUrl;
        private static ZendeskApi api;

        public ZendeskApiManager()
        {
            initialize();
        }

        public ZendeskApiManager(string url, string username, string password)
        {
            api = new ZendeskApi(url, username, password);
        }

        public static ZendeskApi ZendeskApi
        {
            get
            {
                if (api == null)
                {
                    initialize();
                }

                return api;
            }

            private set { api = value; }
        }

        private static void initialize()
        {
            var subdomain = ConfigurationManager.AppSettings["Zendesk_subdomain"];
            var username = ConfigurationManager.AppSettings["Username"];
            var password = ConfigurationManager.AppSettings["Password"];


            apiUrl = "https://" + subdomain + ".zendesk.com/api/v2";
            api = new ZendeskApi(apiUrl, username, password);
        }
    }
}