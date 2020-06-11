using Wykop.ApiProvider.Common.Attributes;

namespace Wykop.ApiProvider.Exceptions.ApiExceptions.Factories
{
    [WykopApiExceptionFactory(ApiErrorCode.ServiceMaintenance)]
    public class WykopServiceMaintenceExceptionFactory : IWykopApiExceptionFactory
    {
        public WykopApiException GetWykopApiException(ApiErrorCode apiErrorCode, string requestUrl)
        {
            return new WykopApiException(apiErrorCode, requestUrl, 
                                        "Wykop API is unavailable now - it is in maintenance state.");
        }
    }
}