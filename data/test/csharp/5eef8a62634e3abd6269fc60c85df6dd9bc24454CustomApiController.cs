using System.Web.Http;

namespace FamilyTasks.Api.Controller.ApiResults
{
    public class CustomApiController : ApiController
    {
        public ApiResult ErrorApiResult(int errorCode, string message)
        {
            return new ApiResult(Request, errorCode, message, null);
        }

        public ApiResult EmptyApiResult()
        {
            return new ApiResult(Request, 0, null, null);
        }

        public ApiResult SuccessApiResult(object result)
        {
            return new ApiResult(Request, 0, null, result);
        }
    }
}