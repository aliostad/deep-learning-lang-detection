using System;
using XCClientAPICommon.Client;
using XComponent.TradeCapture.TradeApi;

namespace TradeSender
{
    class ClientApiHelper : IDisposable
    {
        static readonly ClientApiHelper _instance = new ClientApiHelper();
        private TradeApi _tradeApi;

        private ClientApiHelper()
        {
            
        }

        public static ClientApiHelper Instance
        {
            get
            {
                return _instance;                
            }
        }

        public bool Init()
        {
            _tradeApi = new TradeApi();
           InitReport tradeReport;
           return _tradeApi.Init(out tradeReport);
        }

        public TradeApi Api
        {
            get
            {
                return _tradeApi;
            }
        }

        public void Dispose()
        {
            _tradeApi.Dispose();
        }
    }
}
