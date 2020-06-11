using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Pogodynka.Utility
{
    public static class ClientSettings
    {

        public static string ApiKey = "!!! KLUCZ API !!!";
        public static string ApiUrl = "http://api.openweathermap.org/data/2.5";

        public static void SetApiKey(string apiKey)
        {
            ApiKey = apiKey;
        }

        public static void SetApiUrl(string apiUrl)
        {
            ApiUrl = apiUrl;
        }

    }
}
