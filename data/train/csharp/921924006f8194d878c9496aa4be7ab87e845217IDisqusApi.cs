namespace Disqus.NET
{
    public interface IDisqusApi
    {
        IDisqusApplicationsApi Applications { get; }
        IDisqusBlacklistsApi Blacklists { get; }
        IDisqusCategoryApi Category { get; }
        IDisqusExportsApi Exports { get; }
        IDisqusForumCategoryApi ForumCategory { get; }
        IDisqusForumsApi Forums { get; }
        IDisqusImportsApi Imports { get; }
        IDisqusOrganizationsApi Organizations { get; }
        IDisqusPostsApi Posts { get; }
        IDisqusThreadsApi Threads { get; }
        IDisqusTrendsApi Trends { get; }
        IDisqusTrustedDomainsApi TrustedDomains { get; }
        IDisqusUsersApi Users { get; }
        IDisqusWhitelistsApi Whitelists { get; }
    }
}