namespace WeatherUndergroundService
{
    public static class ClientSettings
    {
        public static string ApiKey = "cfa6b4ca183e981ed5e49e390fb56bde";
        public static string ApiUrl = "http://api.openweathermap.org/data/2.5";
        public static string HistoryApiUrl = "http://history.openweathermap.org/data/2.5";
        public static string InconUrl = "http://openweathermap.org/img/w/";

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