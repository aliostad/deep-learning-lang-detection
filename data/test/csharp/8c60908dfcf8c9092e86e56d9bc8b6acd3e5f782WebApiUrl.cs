using System.Runtime.CompilerServices;
using System.Runtime.Remoting.Messaging;
using ApiProxy.ApiHelpers;

namespace ApiProxy.Shared
{
    public static class BaseWebApiUrl
    {
        private static string _apiUrl;
        
       /// <summary>
       /// Get Base Api Url/Set it if its null
       /// </summary>
        public static string ApiUrl
        {
            get
            {
                if (string.IsNullOrEmpty(_apiUrl))
                {
                    _apiUrl = Helpers.GetWebApiUrl();
                    return _apiUrl;
                }
                else
                {
                    return _apiUrl;
                }
            }
        }







    }
}