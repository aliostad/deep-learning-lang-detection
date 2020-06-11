using System.Net;
using DemoApi.Data.HttpHelper;

namespace DemoApi.Data.Extensions
{
    public static class HttpWebRequestExtension
    {
        public static ApiResponse GetApiResponse(this HttpWebRequest request)
        {
            ApiResponse apiResponse;

            try
            {
                apiResponse = new ApiResponse(request.GetResponse());
            }
            catch (WebException ex)
            {
                apiResponse = new ApiResponse(ex.Response, ex);
            }
            return apiResponse;
        }
    }
}
