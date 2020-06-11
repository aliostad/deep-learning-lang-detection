using Wykop.ApiProvider.Common.Attributes;

namespace Wykop.ApiProvider.Exceptions.ApiExceptions.Factories
{
    [WykopApiExceptionFactory(ApiErrorCode.InvalidParametersSended)]
    [WykopApiExceptionFactory(ApiErrorCode.NotEnoughParameters)]
    [WykopApiExceptionFactory(ApiErrorCode.NoResourceSpecifedInRequest)]
    [WykopApiExceptionFactory(ApiErrorCode.ApiCheating)]
    public class InvalidRequestParametersExceptionFactory : IWykopApiExceptionFactory
    {
        public WykopApiException GetWykopApiException(ApiErrorCode apiErrorCode, string requestUrl)
        {
            var exceptionReason = "The request created by library contains invalid parameters/resource target - contact library author.";
            return new InvalidWykopApiRequestException(apiErrorCode, requestUrl, exceptionReason);
        }
    }
}