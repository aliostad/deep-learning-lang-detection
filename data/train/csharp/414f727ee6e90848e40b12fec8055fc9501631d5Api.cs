using LinqToNewRelic.Implementations;

namespace LinqToNewRelic
{
    public class Api
    {
        private readonly string _apiKey;
        private UserApi _user;
        private IApplicationQueries _applications;
        private IServerQueries _servers;

        public Api(string apiKey)
        {
            _apiKey = apiKey;
        }

        public IUserQueries Users { get { return _user ?? (_user = new UserApi(_apiKey)); } }
        public IApplicationQueries Applications { get { return _applications ?? (_applications = new ApplicationApi(_apiKey)); } }
        public IServerQueries Servers { get { return _servers ?? (_servers = new ServerApi(_apiKey)); } }
    }
}
