namespace CurrencyCloud.Environment
{
    /// <summary>
    /// Contains URLs of eligible API servers.
    /// </summary>
    public class ApiServer
    {
        private ApiServer(string url)
        {
            Url = url;
        }

        public readonly string Url;

        public static readonly ApiServer Demo = new ApiServer("https://devapi.currencycloud.com");
        public static readonly ApiServer Production = new ApiServer("https://api.currencycloud.com");
        public static readonly ApiServer UAT = new ApiServer("https://api-uat1.ccycloud.com");
        public static readonly ApiServer Mock = new ApiServer("http://localhost:5555");
    }
}
