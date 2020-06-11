using System;

namespace EcanMatching.Domain.Exceptions
{
    public class ApiUnreachableException : Exception
    {
        public string ApiName { get; set; }

        public ApiUnreachableException(string apiName)
            : base(StdMessage(apiName))
        {
            ApiName = apiName;
        }

        public ApiUnreachableException(string apiName, Exception innerException)
            : base(StdMessage(apiName), innerException)
        {
            ApiName = apiName;
        }

        private static string StdMessage(string apiName)
        {
            return "Could not connect to " + apiName;
        }
    }
}
