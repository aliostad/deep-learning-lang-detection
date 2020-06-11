namespace SlackCleanup.SlackApiImplementation
{
    public interface ISlackApi
    {
        IChannelsApi Channels { get; set; }
        IChatApi Chat { get; set; }
        IFilesApi Files { get; set; }
        IGroupsApi Groups { get; set; }
        IImApi Im { get; set; }
        IReactionsApi Reactions { get; set; }
        ISearchApi Search { get; set; }
        ITeamApi Team { get; set; }
        IUsersApi Users { get; set; }
        IRtmApi Rtm { get; set; }
        IApiApi Api { get; set; }
        IAuthApi Auth { get; set; }
        IEmojiApi Emoji { get; set; }
        IStarsApi Stars { get; set; }
        IOauthApi Oauth { get; set; }
    }
}