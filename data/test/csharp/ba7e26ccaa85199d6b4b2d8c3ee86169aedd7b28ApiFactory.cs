using SocialNetwork_UWP.Business.Factories.Interfaces;
using SocialNetwork_UWP.Data.Api.SocialNetworkApi.Auth.Implementations;
using SocialNetwork_UWP.Data.Api.SocialNetworkApi.Auth.Interfaces;
using SocialNetwork_UWP.Data.Api.SocialNetworkApi.Social.Implementations;
using SocialNetwork_UWP.Data.Api.SocialNetworkApi.Social.Interfaces;

namespace SocialNetwork_UWP.Business.Factories.Implementations
{
    public class ApiFactory : IApiFactory
    {
        public IAuthApi AuthApi => new AuthApi();

        public ISocialApi SocialApi => new SocialApi();
    }
}
