using System;

namespace EcanMatching.Domain.Exceptions
{
    public class ApiUnauthorisedException : Exception
    {
        public string ApiName { get; set; }

        public ApiUnauthorisedException(string apiName)
            : base(StdMessage(apiName))
        {
            ApiName = apiName;
        }

        public ApiUnauthorisedException(string apiName, Exception innerException)
            : base(StdMessage(apiName), innerException)
        {
            ApiName = apiName;
        }

        private static string StdMessage(string apiName)
        {
            return string.Format("Unauthorised when trying to connect to {0}", apiName);
        }
    }
}
