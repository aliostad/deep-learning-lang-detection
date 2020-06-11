using JustGiving.Api.Sdk.ApiClients;
using JustGiving.Api.Sdk.Http;
using JustGiving.Api.Sdk.WindowsPhone7.Http.SilverlightPhone7;

namespace JustGiving.Api.Sdk.WindowsPhone7
{
    public class JustGivingMobileClient : JustGivingClientBase
    {
        public JustGivingMobileClient(string apiKey)
            : base(new ClientConfiguration(apiKey), new SilverlightHttpClient(), null, null, null, null, null, null, null, null, null, null, null)
        {
        }

        public JustGivingMobileClient(ClientConfiguration clientConfiguration)
            : base(clientConfiguration, new SilverlightHttpClient(), null, null, null, null, null, null, null, null, null, null, null)
        {
        }

        public JustGivingMobileClient(ClientConfiguration clientConfiguration, IHttpClient httpClient)
            : base(clientConfiguration, httpClient, null, null, null, null, null, null, null, null, null, null, null)
        {
        }

        public JustGivingMobileClient(ClientConfiguration clientConfiguration, IHttpClient httpClient,
                                      IAccountApi accountApi,
                                      IDonationApi donationApi, IPageApi pageApi, ISearchApi searchApi,
                                      ICharityApi charityApi,
                                      IEventApi eventApi, ITeamApi teamApi, IOneSearchApi oneSearchApi,
                                      ICountryApi countryApi, ICurrencyApi currencyApi, IProjectApi projectApi)
            : base(
                clientConfiguration, httpClient, accountApi, donationApi, pageApi, searchApi, charityApi, eventApi,
                teamApi, oneSearchApi, countryApi, currencyApi, projectApi)
        {
        }
    }
}
