using System;
using System.Threading.Tasks;
using SocialNetwork_UWP.Data.Api.SocialNetworkApi.Auth.Entities;
using SocialNetwork_UWP.Data.Api.SocialNetworkApi.Auth.Interfaces;
using SocialNetwork_UWP.Data.Api.SocialNetworkApi.Social.Entities;

namespace SocialNetwork_UWP.Data.Api.SocialNetworkApi.Auth.Implementations
{
    public class AuthApi : IAuthApi
    {
        private readonly RestApi _restApi;

        public AuthApi()
        {
            var apiRouting = new ApiRouting();
            var apiServerAddress = apiRouting.SocialNetworkApiUrl;

            _restApi = new RestApi(new Uri(apiServerAddress));
        }

        public Task<SessionInfo> Login(string username, string password)
        {
            return _restApi.Login("password", username, password);
        }

        public Task Register(string email, string password, string confirmPassword)
        {
            return _restApi.Register(email, password, confirmPassword);
        }

        public Task ChangePassword(string oldPassword, string newPassword, string confirmPassword)
        {
            return _restApi.ChangePassword(oldPassword, newPassword, confirmPassword);
        }
    }
}
