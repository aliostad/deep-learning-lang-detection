using System;
using EzTextingApiClient.Api.Contacts;
using EzTextingApiClient.Api.Credits;
using EzTextingApiClient.Api.Groups;
using EzTextingApiClient.Api.Inbox;
using EzTextingApiClient.Api.Keywords;
using EzTextingApiClient.Api.Media;
using EzTextingApiClient.Api.Messaging;
using EzTextingApiClient.Api.Toolbox;
using EzTextingApiClient.Auth;
using RestSharp.Authenticators;

namespace EzTextingApiClient
{
    ///
    /// EzTexting API client
    /// <p>
    /// <b>Authentication:</b> the CallFire API V2 uses HTTP Basic Authentication to verify
    /// the user of an endpoint. A generated username/password API credential from your
    /// account settings is required.
    /// </p>
    /// <b>Errors:</b> codes in the 400s range detail all of the errors a EzTexting Developer could
    /// encounter while using the API. Bad Request, Rate Limit Reached, and Unauthorized
    /// are some of the sorts of responses in the 400s block. Codes in the 500s range are
    /// error responses from the EzTexting system. If an error has occurred anywhere in
    /// the execution of a resource that was not due to user input, a 500 response
    /// will be returned with a corresponding JSON error body. In that body will contain a message
    /// detailing what went wrong.
    /// API client methods throw 2 types of exceptions: API and client itself. API exception contains HTTP response code.
    /// <ul>
    /// <li>{@link EzTextingClientException} - if error occurred inside client</li>
    /// <li>{@link EzTextingApiException} - if server returns any code higher than 400</li>
    /// </ul>
    ///
    /// Author: Vladimir Mikhailov (email: vmikhailov@callfire.com)
    /// <a href="https://www.eztexting.com/developers/sms-api-documentation/rest">EzTexting API documentation</a>
    /// <a href="https://github.com/CallFire/eztexting-api-client-csharp/blob/master/docs/api/ApiExamples.adoc">HowTos and examples</a>
    /// <a href="http://stackoverflow.com/questions/tagged/callfire">Stackoverflow community questions</a>
    public class EzTextingClient
    {
        public RestApiClient RestApiClient { get; set; }

        private readonly Lazy<MessagingApi> _messagingApi;
        private readonly Lazy<InboxApi> _inboxApi;
        private readonly Lazy<CreditsApi> _creditsApi;
        private readonly Lazy<KeywordsApi> _keywordsApi;
        private readonly Lazy<ContactsApi> _contactsApi;
        private readonly Lazy<GroupsApi> _groupsApi;
        private readonly Lazy<MediaLibraryApi> _mediaLibraryApi;
        private readonly Lazy<ToolboxApi> _toolboxApi;

        public MessagingApi MessagingApi => _messagingApi.Value;
        public InboxApi InboxApi => _inboxApi.Value;
        public CreditsApi CreditsApi => _creditsApi.Value;
        public KeywordsApi KeywordsApi => _keywordsApi.Value;
        public ContactsApi ContactsApi => _contactsApi.Value;
        public GroupsApi GroupsApi => _groupsApi.Value;
        public MediaLibraryApi MediaLibraryApi => _mediaLibraryApi.Value;
        public ToolboxApi ToolboxApi => _toolboxApi.Value;

        public EzTextingClient(string username, string password) : this(Brand.Ez, username, password)
        {
        }

        public EzTextingClient(Brand brand, string username, string password)
        {
            RestApiClient = new RestApiClient(brand, new RequestParamAuth(username, password));

            _messagingApi = new Lazy<MessagingApi>(() => new MessagingApi(RestApiClient));
            _inboxApi = new Lazy<InboxApi>(() => new InboxApi(RestApiClient));
            _creditsApi = new Lazy<CreditsApi>(() => new CreditsApi(RestApiClient));
            _keywordsApi = new Lazy<KeywordsApi>(() => new KeywordsApi(RestApiClient));
            _contactsApi = new Lazy<ContactsApi>(() => new ContactsApi(RestApiClient));
            _groupsApi = new Lazy<GroupsApi>(() => new GroupsApi(RestApiClient));
            _mediaLibraryApi = new Lazy<MediaLibraryApi>(() => new MediaLibraryApi(RestApiClient));
            _toolboxApi = new Lazy<ToolboxApi>(() => new ToolboxApi(RestApiClient));
        }
    }
}