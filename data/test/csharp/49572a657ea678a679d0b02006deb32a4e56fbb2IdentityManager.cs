using Jarvis.Core.Api.Slack;
using Jarvis.Core.Models;
using System.Threading.Tasks;

namespace Jarvis.Core.Services
{
    public class IdentityManager
    {
        IUsersIdentityApi Api;

        public IdentityManager(IUsersIdentityApi api)
        {
            Api = api;
        }

        public IdentityManager()
        {
            Api = new UsersIdentityApi();
        }

        public Task<Identity> GetIdentityAsync(string token)
        {
            return Api.GetIdentity(token);
        } 
    }
}
