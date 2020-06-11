using System;

namespace EcanMatching.Domain.Exceptions
{
    public class ApiConnectionException : Exception
    {
        public string ApiName { get; set; }

        public ApiConnectionException(string apiName)
            : base(StdMessage(apiName))
        {
            ApiName = apiName;
        }

        public ApiConnectionException(string apiName, Exception innerException)
            : base(StdMessage(apiName), innerException)
        {
            ApiName = apiName;
        }

        private static string StdMessage(string apiName)
        {
            return string.Format("Unexpected error trying to connect to {0}", apiName);
        }
    }
}
