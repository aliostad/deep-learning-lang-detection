using System;
using System.Threading.Tasks;
using SocialNetwork_UWP.Data.Api.SocialNetworkApi.Social.Entities;
using SocialNetwork_UWP.Data.Api.SocialNetworkApi.Social.Interfaces;

namespace SocialNetwork_UWP.Data.Api.SocialNetworkApi.Social.Implementations
{
    public class SocialApi : ISocialApi
    {
        private readonly RestApi _restApi;

        public SocialApi()
        {
            var apiRouting = new ApiRouting();
            var apiBaseAddress = apiRouting.SocialNetworkApiUrl;

            _restApi = new RestApi(new Uri(apiBaseAddress));
        }

        public Task<User> GetUser()
        {
            return _restApi.GetUser();
        }

        public Task<Profile> GetProfile()
        {
            return _restApi.GetProfile();
        }

        public Task<Profile> GetProfileOf(int userId)
        {
            return _restApi.GetProfileByUserId(userId);
        }

        public Task<Profile> CreateProfile(Profile profile)
        {
            return _restApi.CreateProfile(profile);
        }

        public Task<Profile> UpdateProfile(Profile profile)
        {
            return _restApi.UpdateProfile(profile);
        }
    }
}