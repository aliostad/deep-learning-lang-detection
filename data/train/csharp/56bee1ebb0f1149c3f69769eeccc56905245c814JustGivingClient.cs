using System;
using JustGiving.Api.Sdk.ApiClients;
using JustGiving.Api.Sdk.Http;
using JustGiving.Api.Sdk.Http.MicrosoftHttp;

namespace JustGiving.Api.Sdk
{
    public class JustGivingClient : JustGivingClientBase
    {
        public JustGivingClient(string apiKey)
            : base(
                new ClientConfiguration(apiKey), new HttpClientWrapper(), null, null, null, null, null, null, null, null,
                null, null, null)
        {
        }

        public JustGivingClient(ClientConfiguration clientConfiguration)
            : base(
                clientConfiguration, new HttpClientWrapper(), null, null, null, null, null, null, null, null, null, null, null
                )
        {
        }

        public JustGivingClient(ClientConfiguration clientConfiguration, IHttpClient httpClient)
            : base(clientConfiguration, httpClient, null, null, null, null, null, null, null, null, null, null, null)
        {
        }

        public JustGivingClient(ClientConfiguration clientConfiguration, IHttpClient httpClient, IAccountApi accountApi,
                                IDonationApi donationApi, IPageApi pageApi, ISearchApi searchApi, ICharityApi charityApi,
                                IEventApi eventApi, ITeamApi teamApi, IOneSearchApi oneSearch, ICountryApi countryApi,
                                ICurrencyApi currencyApi, IProjectApi projectApi)
            : base(
                clientConfiguration, httpClient, accountApi, donationApi, pageApi, searchApi, charityApi, eventApi,
                teamApi, oneSearch, countryApi, currencyApi, projectApi)
        {
        }
    }
}
