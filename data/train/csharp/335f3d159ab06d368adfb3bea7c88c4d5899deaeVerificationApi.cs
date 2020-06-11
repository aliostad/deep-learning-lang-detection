using Sinch.ServerSdk.Models;

namespace Sinch.ServerSdk.Verification.Fluent
{
    public class VerificationApi : IVerificationApi
    {
        private readonly IVerificationApiEndpoints _api;

        internal VerificationApi(IVerificationApiEndpoints api)
        {
            _api = api;
        }

        public IVerification Verification()
        {
            return new Verification(_api);
        }
        public IVerification Verification(string number)
        {
            return new Verification(_api, new IdentityModel { Type = "number", Endpoint = number } );
        }
    }
}
