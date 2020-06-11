using System;
using System.Runtime.Serialization;
using Fusebill.ApiWrapper.Dto;

namespace Fusebill.ApiWrapper
{
    [Serializable]
    public class ApiClientException : Exception
    {
        public ApiError ApiError { get; private set; }

        public ApiClientException() { }

        public ApiClientException(string message) : base(message) { }

        public ApiClientException(ApiError apiError) : this(apiError.ToString(), (Exception)null, apiError) { }

        public ApiClientException(string message, Exception innerException) : base(message, innerException) { }

        public ApiClientException(string message, Exception innerException, ApiError apiError)
            : base(message, innerException)
        {
            ApiError = apiError;
        }

        public ApiClientException(SerializationInfo info, StreamingContext context)
            : base(info, context)
        {
            if (null != info)
            {
                ApiError = (ApiError)info.GetValue("ApiError", typeof(ApiError));
            }
        }

        public override void GetObjectData(SerializationInfo info, StreamingContext context)
        {
            base.GetObjectData(info, context);

            if (null != info)
            {
                info.AddValue("ApiError", ApiError);
            }
        }
    }
}
