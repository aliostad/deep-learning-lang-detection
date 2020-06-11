using System;
using RestSharp.Authenticators;
using CallfireApiClient.Api.Account;
using CallfireApiClient.Api.Webhooks;
using CallfireApiClient.Api.Contacts;
using CallfireApiClient.Api.Numbers;
using CallfireApiClient.Api.Keywords;
using CallfireApiClient.Api.CallsTexts;
using CallfireApiClient.Api.Campaigns;

namespace CallfireApiClient
{
    /// <summary>
    /// Callfire API v2 .NET client
    /// use your API login and password to create client instance object
    /// </summary>
    public class CallfireClient
    {

        public void SetClientConfig(ClientConfig config)
        {
            RestApiClient.ClientConfig = config;
        }

        public RestApiClient RestApiClient { get; set; }

        readonly Lazy<MeApi> _MeApi;
        readonly Lazy<OrdersApi> _OrdersApi;
        readonly Lazy<BatchesApi> _BatchesApi;
        readonly Lazy<CampaignSoundsApi> _CampaignSoundsApi;
        readonly Lazy<ContactsApi> _ContactsApi;
        readonly Lazy<ContactListsApi> _ContactListsApi;
        readonly Lazy<NumbersApi> _NumbersApi;
        readonly Lazy<NumberLeasesApi> _NumberLeasesApi;
        readonly Lazy<KeywordsApi> _KeywordsApi;
        readonly Lazy<KeywordLeasesApi> _KeywordLeasesApi;
        readonly Lazy<DncApi> _DncApi;
        readonly Lazy<CallsApi> _CallsApi;
        readonly Lazy<TextsApi> _TextsApi;
        readonly Lazy<TextAutoRepliesApi> _TextAutoRepliesApi;
        readonly Lazy<TextBroadcastsApi> _TextBroadcastsApi;
        readonly Lazy<CallBroadcastsApi> _CallBroadcastsApi;
        readonly Lazy<MediaApi> _MediaApi;
        readonly Lazy<WebhooksApi> _WebhooksApi;

        public MeApi MeApi { get { return _MeApi.Value; } }

        public OrdersApi OrdersApi { get { return _OrdersApi.Value; } }

        public BatchesApi BatchesApi { get { return _BatchesApi.Value; } }

        public CampaignSoundsApi CampaignSoundsApi { get { return _CampaignSoundsApi.Value; } }

        public ContactsApi ContactsApi { get { return _ContactsApi.Value; } }

        public ContactListsApi ContactListsApi { get { return _ContactListsApi.Value; } }

        public NumbersApi NumbersApi { get { return _NumbersApi.Value; } }

        public NumberLeasesApi NumberLeasesApi { get { return _NumberLeasesApi.Value; } }

        public WebhooksApi WebhooksApi { get { return _WebhooksApi.Value; } }

        public KeywordsApi KeywordsApi { get { return _KeywordsApi.Value; } }

        public KeywordLeasesApi KeywordLeasesApi { get { return _KeywordLeasesApi.Value; } }

        public DncApi DncApi { get { return _DncApi.Value; } }

        public CallsApi CallsApi { get { return _CallsApi.Value; } }

        public TextsApi TextsApi { get { return _TextsApi.Value; } }

        public TextAutoRepliesApi TextAutoRepliesApi { get { return _TextAutoRepliesApi.Value; } }

        public TextBroadcastsApi TextBroadcastsApi { get { return _TextBroadcastsApi.Value; } }

        public CallBroadcastsApi CallBroadcastsApi { get { return _CallBroadcastsApi.Value; } }

        public MediaApi MediaApi { get { return _MediaApi.Value; } }

        public CallfireClient(string username, string password)
        {
            RestApiClient = new RestApiClient(new HttpBasicAuthenticator(username, password));

            _MeApi = new Lazy<MeApi>(() => new MeApi(RestApiClient));
            _OrdersApi = new Lazy<OrdersApi>(() => new OrdersApi(RestApiClient));
            _BatchesApi = new Lazy<BatchesApi>(() => new BatchesApi(RestApiClient));
            _CampaignSoundsApi = new Lazy<CampaignSoundsApi>(() => new CampaignSoundsApi(RestApiClient));
            _ContactsApi = new Lazy<ContactsApi>(() => new ContactsApi(RestApiClient));
            _ContactListsApi = new Lazy<ContactListsApi>(() => new ContactListsApi(RestApiClient));
            _NumbersApi = new Lazy<NumbersApi>(() => new NumbersApi(RestApiClient));
            _NumberLeasesApi = new Lazy<NumberLeasesApi>(() => new NumberLeasesApi(RestApiClient));
            _WebhooksApi = new Lazy<WebhooksApi>(() => new WebhooksApi(RestApiClient));
            _KeywordsApi = new Lazy<KeywordsApi>(() => new KeywordsApi(RestApiClient));
            _KeywordLeasesApi = new Lazy<KeywordLeasesApi>(() => new KeywordLeasesApi(RestApiClient));
            _DncApi = new Lazy<DncApi>(() => new DncApi(RestApiClient));
            _CallsApi = new Lazy<CallsApi>(() => new CallsApi(RestApiClient));
            _TextsApi = new Lazy<TextsApi>(() => new TextsApi(RestApiClient));
            _TextAutoRepliesApi = new Lazy<TextAutoRepliesApi>(() => new TextAutoRepliesApi(RestApiClient));
            _TextBroadcastsApi = new Lazy<TextBroadcastsApi>(() => new TextBroadcastsApi(RestApiClient));
            _CallBroadcastsApi = new Lazy<CallBroadcastsApi>(() => new CallBroadcastsApi(RestApiClient));
            _MediaApi = new Lazy<MediaApi>(() => new MediaApi(RestApiClient));
        }
    }
}
