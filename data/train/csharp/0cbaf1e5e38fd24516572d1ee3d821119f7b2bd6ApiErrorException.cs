using System;

namespace EcanMatching.Domain.Exceptions
{
    public class ApiErrorException : Exception
    {
        public string ApiName { get; set; }

        public ApiErrorException(string apiName)
            : base(StdMessage(apiName))
        {
            ApiName = apiName;
        }

        public ApiErrorException(string apiName, Exception innerException)
            : base(StdMessage(apiName), innerException)
        {
            ApiName = apiName;
        }

        private static string StdMessage(string apiName)
        {
            return string.Format("Internal server error in {0}. Check service logs.", apiName);
        }
    }
}
