using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using CsRestClient;
using CsRestClient.Attributes;

namespace Sample.Github
{
    public class GithubAPI
    {
        public string authString { get; set; }
        
        public UserAPI user { get; set; }

        public RepoAPI GetRepo(string owner, string name)
        {
            var api = GithubAPIFactory.Create<RepoAPI>(authString);
            api.owner = owner;
            api.name = name;
            return api;
        }
        public GistAPI GetGist(string id)
        {
            var api = GithubAPIFactory.Create<GistAPI>(authString);
            api.id = id;
            return api;
        }
    }
    
    public static class GithubAPIFactory
    {
        public static GithubAPI Create(string username, string password)
        {
            var api = new GithubAPI();

            api.authString = "Basic " + Convert.ToBase64String(
                Encoding.UTF8.GetBytes($"{username}:{password}"));

            api.user = Create<UserAPI>(api.authString);

            return api;
        }
        internal static T Create<T>(string authString)
            where T : APIBase
        {
            var api = RemotePoint.Create<T>("https://api.github.com");
            api.authString = authString;          
            return api;
        }
    }
}
