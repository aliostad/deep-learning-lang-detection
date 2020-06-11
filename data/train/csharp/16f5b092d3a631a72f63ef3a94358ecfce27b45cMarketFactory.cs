using Ayx.Cryptocurrency.API;
using Ayx.Cryptocurrency.API.Markets.Bitfinex;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace APITests
{
    class MarketFactory
    {
        private static Btc38API btc38API;
        public static Btc38API Btc38API
        {
            get
            {
                if (btc38API == null)
                {
                    var lines = File.ReadAllLines("C:\\btc38.txt");
                    btc38API = new Btc38API(lines[0], lines[1], lines[2]);
                }
                return btc38API;
            }
        }

        private static BittrexAPI bittrexAPI;

        public static BittrexAPI BittrexAPI
        {
            get
            {
                if (bittrexAPI == null)
                {
                    var lines = File.ReadAllLines("C:\\bittrex.txt");
                    bittrexAPI = new BittrexAPI(lines[0], lines[1]);
                }
                return bittrexAPI;
            }
        }

        private static PoloniexAPI poloniexAPI;

        public static PoloniexAPI PoloniexAPI
        {
            get
            {
                if (poloniexAPI == null)
                {
                    var lines = File.ReadAllLines("C:\\poloniex.txt");
                    poloniexAPI = new PoloniexAPI(lines[0], lines[1]);
                }
                return poloniexAPI;
            }
        }

        private static JubiAPI jubiAPI;

        public static JubiAPI JubiAPI
        {
            get
            {
                if (jubiAPI == null)
                {
                    var lines = File.ReadAllLines("C:\\jubi.txt");
                    jubiAPI = new JubiAPI(lines[0], lines[1]);
                }
                return jubiAPI;
            }
        }

        private static BterAPI bterAPI;

        public static BterAPI BterAPI
        {
            get
            {
                if (bterAPI == null)
                {
                    var lines = File.ReadAllLines("C:\\bter.txt");
                    bterAPI = new BterAPI(lines[0], lines[1]);
                }
                return bterAPI;
            }
        }

        private static BitfinexAPI bitfinexAPI;

        public static BitfinexAPI BitfinexAPI
        {
            get
            {
                if (bitfinexAPI == null)
                {
                    var lines = File.ReadAllLines("C:\\bitfinex.txt");
                    bitfinexAPI = new BitfinexAPI(lines[0], lines[1]);
                }
                return bitfinexAPI;
            }
        }

        public static BitfinexMarket Bitfinex
        {
            get
            {
                var lines = File.ReadAllLines("C:\\bitfinex.txt");
                return new BitfinexMarket(lines[0], lines[1]);
            }
        }
    }
}
