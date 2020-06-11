using LunoApi.Net.Accounts;
using LunoApi.Net.Common;
using LunoApi.Net.MarketData;
using LunoApi.Net.Quotes;
using System;
using System.Collections.Generic;
using System.Text;

namespace LunoApi.Net
{
    public sealed class LunoApi
    {
        public IMarketDataApi MarketDataApi { get; private set; }
        public IAccountsApi AccountsApi { get; private set; }
        public IQuotesApi QuotesApi { get; private set; }
        public LunoApi(IConfig lunoConfig)
        {
            var lunoApiClient = new LunoApiClient(lunoConfig);
            MarketDataApi = new MarketDataApi(lunoApiClient);
            AccountsApi = new AccountsApi(lunoApiClient);
            QuotesApi = new QuotesApi(lunoApiClient);
        }
    }
}
