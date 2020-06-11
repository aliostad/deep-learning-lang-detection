using System.Net;
using CybercomDemoCore.Models.Abstract.Api;

namespace CybercomDemoCore.Models.Api
{
    public class ApiResponse<T> : IApiResponse<T>
    {
        public bool IsSuccess { get; set; }

        public HttpStatusCode StatusCode { get; set; }

        public string ReasonPhrase { get; set; }

        public ApiInfo ApiInfo { get; set; }

        public T DataResult { get; set; }

        //public static ApiResponse<T> Succeeded(T dataResult, ApiInfo apiInfo)
        //    => new ApiResponse<T>
        //    {
        //        ApiInfo = apiInfo,
        //        DataResult = dataResult
        //    };

        public static ApiResponse<T> Failed(ApiInfo apiInfo)
            => new ApiResponse<T>
            {
                ApiInfo = apiInfo
            };
    }
}
