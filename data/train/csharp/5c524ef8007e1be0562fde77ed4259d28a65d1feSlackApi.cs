using System;

namespace SlackCleanup.SlackApiImplementation
{
    public class SlackApi : ISlackApi
    {
        public IChannelsApi Channels { get; set; }
        public IChatApi Chat { get; set; }
        public IFilesApi Files { get; set; }
        public IGroupsApi Groups { get; set; }
        public IImApi Im { get; set; }
        public IReactionsApi Reactions { get; set; }
        public ISearchApi Search { get; set; }
        public ITeamApi Team { get; set; }
        public IUsersApi Users { get; set; }
        public IRtmApi Rtm { get; set; }
        public IApiApi Api { get; set; }
        public IAuthApi Auth { get; set; }
        public IEmojiApi Emoji { get; set; }
        public IStarsApi Stars { get; set; }
        public IOauthApi Oauth { get; set; }

        private SlackApi() { }

        public static ISlackApi Create(string apiKey)
        {
            return Create(new RestSharpRequestHandler(apiKey));
        }

        private static ISlackApi Create(IRequestHandler requestHandler)
        {
            if (requestHandler == null)
                throw new ArgumentNullException("requestHandler");

            var slackApi = new SlackApi()
            {
                Api = new ApiApi(requestHandler),
                Auth = new AuthApi(requestHandler),
                Channels = new ChannelsApi(requestHandler),
                Chat = new ChatApi(requestHandler),
                Emoji = new EmojiApi(requestHandler),
                Files = new FilesApi(requestHandler),
                Groups = new GroupsApi(requestHandler),
                Im = new ImApi(requestHandler),
                Oauth = new OauthApi(requestHandler),
                Reactions = new ReactionsApi(requestHandler),
                Rtm = new RtmApi(requestHandler),
                Search = new SearchApi(requestHandler),
                Stars = new StarsApi(requestHandler),
                Team = new TeamApi(requestHandler),
                Users = new UsersApi(requestHandler)
            };

            return slackApi;
        }
    }
}
