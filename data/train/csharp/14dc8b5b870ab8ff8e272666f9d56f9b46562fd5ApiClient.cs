namespace WebAPI.Tests.Infrastructure
{
    public class ApiClient
    {
        private readonly IHttpRequester _requester;

        private GroupApiClient _groupApiClient;
        public GroupApiClient Group => _groupApiClient ?? (_groupApiClient = new GroupApiClient(_requester));

        private ApiClientAccount _apiClientAccount;
        public ApiClientAccount Account => _apiClientAccount ?? (_apiClientAccount = new ApiClientAccount(_requester));

        public ApiClient(IHttpRequester requester)
        {
            _requester = requester;
        }

    }
}