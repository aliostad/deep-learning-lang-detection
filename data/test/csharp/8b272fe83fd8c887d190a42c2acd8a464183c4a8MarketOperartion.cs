using MongoDB.Driver;
using NinjaTrader.Cbi;
using NinjaTrader.Custom.MongoDB.Table;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NinjaTrader.Custom.MongoDB.TableOperation
{
    class MarketOperartion
    {
        public static Market insertMarket(IMongoCollection<Market> collection, Instrument instrument)
        {
            Market market = new Market(
                                     instrument.MasterInstrument.Name,
                                     instrument.MasterInstrument.Currency.ToString(),
                                     instrument.MasterInstrument.Description,
                                     instrument.MasterInstrument.InstrumentType.ToString(),
                                     instrument.MasterInstrument.TickSize,
                                     instrument.MasterInstrument.PointValue,
                                     instrument.MasterInstrument.Url.ToString());
            collection.InsertOne(market);

            return market;
        }

        public static UpdateResult updateMarket(IMongoCollection<Market> collection, FilterDefinition<Market> filter, Instrument instrument,  List<Market> result)
        {
            UpdateOptions options = new UpdateOptions();
            options.IsUpsert = true;
            
            UpdateDefinition<Market> definition = createMarketUpdateDefinition(result.First(), instrument.MasterInstrument);
            if( definition != null)
            {
                UpdateResult r = collection.UpdateOne(filter, definition, options);
                return r;
            } else
            {
                return null;
            }
            
        }

        private static UpdateDefinition<Market> createMarketUpdateDefinition(Market market, MasterInstrument instrument)
        {
            UpdateDefinition<Market> definition = null;

            if (market.Currency == null || !market.Currency.Equals(instrument.Currency.ToString()))
            {
                definition = Definitions<Market>.setUpdateDefinition(definition, Market.Field.CURRENCY.ToString(), instrument.Currency.ToString());
            }

            if (market.Description == null || !market.Description.Equals(instrument.Description))
            {
                definition = Definitions<Market>.setUpdateDefinition(definition, Market.Field.DESCRIPTION.ToString(), instrument.Description);
            }

            if (market.Type == null || !market.Type.Equals(instrument.InstrumentType.ToString()))
            {
                definition = Definitions<Market>.setUpdateDefinition(definition, Market.Field.TYPE.ToString(), instrument.InstrumentType.ToString());
            }

            if (market.TickSize != instrument.TickSize)
            {
                definition = Definitions<Market>.setUpdateDefinition(definition, Market.Field.TICK_SIZE.ToString(), instrument.TickSize);
            }

            if (market.PointValue != instrument.PointValue)
            {
                definition = Definitions<Market>.setUpdateDefinition(definition, Market.Field.POINT_VALUE.ToString(), instrument.PointValue);
            }

            if (market.Url == null || !market.Url.Equals(instrument.Url.ToString()))
            {
                definition = Definitions<Market>.setUpdateDefinition(definition, Market.Field.URL.ToString(), instrument.Url.ToString());
            }
            return definition;
        }
    }
}
