using System;
using System.Runtime.CompilerServices;

namespace FunctionalTesting
{
    public class ApiResult
    {
        public bool IsSuccessful { get; }
        public bool IsFailure => !IsSuccessful;
        public string ApiCall { get; }
        public string ErrorCode { get; }

        internal ApiResult(bool isSuccessful, string apiCall, string errorCode)
        {
            IsSuccessful = isSuccessful;
            ApiCall = apiCall;
            ErrorCode = errorCode;
        }

        public static ApiResult Ok(string apiCall)
        {
            return new ApiResult(true, apiCall, "0");
        }

        public static ApiResult Fail(string apiCall, string errorCode)
        {
            return new ApiResult(false, apiCall, errorCode);
        }

        public static ApiResult<T> Ok<T>(string apiCall, T value)
        {
            return new ApiResult<T>(value, true, apiCall, "0");
        }

        public static ApiResult<T> Fail<T>(string apiCall, string errorCode)
        {
            return new ApiResult<T>(default(T), false, apiCall, errorCode);
        }
    }

    public class ApiResult<T>
    {
        public bool IsSuccessful { get; }
        public bool IsFailure => !IsSuccessful;
        public string ApiCall { get; }
        public string ErrorCode { get; }
        public T Value { get; }

        internal ApiResult(T value, bool isSuccessful, string apiCall, string errorCode)
        {
            Value = value;
            IsSuccessful = isSuccessful;
            ApiCall = apiCall;
            ErrorCode = errorCode;
        }

        //public static implicit operator ApiResult(ApiResult<T> result)
        //{
        //    return result.IsSuccessful ? ApiResult.Ok(result.ApiCall) : ApiResult.Fail(result.ApiCall, result.ErrorCode);
        //}

        //public static implicit operator ApiResult<T>(ApiResult result)
        //{
        //    return result.IsSuccessful ? ApiResult.Ok(result.ApiCall, default(T)) : ApiResult.Fail<T>(result.ApiCall, result.ErrorCode);
        //}
    }
}