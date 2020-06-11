using Api30.Lib;

namespace Api30
{
    public class Environment
    {
        private string _apiUrl;

        public string ApiUrl
        {
            get { return _apiUrl; }
        }

        private string _apiQueryUrl;

        public string ApiQueryUrl
        {
            get { return _apiQueryUrl; }
        }

        //public Environment(EnvironmentType env)
        //{
        //    if (env == EnvironmentType.Sandbox)
        //        Sandbox();
        //    else if (env == EnvironmentType.Production)
        //        Production();
        //    else
        //        Production();
        //}

        private Environment(string apiUrl, string apiQueryUrl)
        {
            _apiUrl = apiUrl;
            _apiQueryUrl = apiQueryUrl;
        }

        public static Environment Sandbox()
        {
            //_apiUrl = Constants.SANDBOX_API_URL;
            //_apiQueryUrl = Constants.SANDBOX_API_QUERY_URL;
            return new Environment(Constants.SANDBOX_API_URL, Constants.SANDBOX_API_QUERY_URL);
        }

        public static Environment Production()
        {
            //_apiUrl = Constants.PRODUCTION_API_URL;
            //_apiQueryUrl = Constants.PRODUCTION_API_QUERY_URL;
            return new Environment(Constants.PRODUCTION_API_URL, Constants.PRODUCTION_API_QUERY_URL);
        }
    }
}