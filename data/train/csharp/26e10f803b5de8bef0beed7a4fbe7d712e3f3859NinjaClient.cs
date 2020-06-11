using System;
using NinjaTrader.Client;

namespace Transaq2NinjaTrader
{
    class NinjaClient
    {
        private Client client = new Client();


        public void SendLast(string instrument, double value, int size)
        {
            //client.Last(instrument, value, size);
        }

        public void SendBid(string instrument, double value, int size)
        {
            //client.Bid(instrument, value, size);
        }

        public void SendAsk(string instrument, double value, int size)
        {
            //client.Ask(instrument, value, size);
        }
        
        public void SendHistory(string instrument, double last, double bid, double ask, int size, DateTime date)
        {
            /*var timestamp = date.ToString("yyyyMMddhhmmss");
            client.LastPlayback(instrument, last, size, timestamp);
            client.BidPlayback(instrument, last, size, timestamp);
            client.AskPlayback(instrument, last, size, timestamp);*/
        }
    }
}
