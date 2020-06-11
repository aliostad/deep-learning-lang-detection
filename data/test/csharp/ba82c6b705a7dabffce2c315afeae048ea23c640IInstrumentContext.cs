using MongoDB.Driver;

namespace MarketCrawler
{

    class InstrumentContext 
    {
        private IMongoDatabase db;
        public InstrumentContext()
        {
            MongoClient client = new MongoClient();
            this.db = client.GetDatabase("clientlist");
            var collection = db.GetCollection<Instrument>("instrument");
            var mismatches = db.GetCollection<Instrument>("mismatches");
            var igniteCollection = db.GetCollection<GlobalQuoteExtend>("igniteInstrument");
        }
        public IMongoCollection<Instrument> Instruments
        {
            get
            {
                return db.GetCollection<Instrument>("Instrument");

            }

        }
        public IMongoCollection<GlobalQuoteExtend> IgniteInstruments
        {
            get
            {
                return db.GetCollection<GlobalQuoteExtend>("igniteInstrument");

            }

        }
        public IMongoCollection<Instrument> mismatchInstruments
        {
            get
            {
                return db.GetCollection<Instrument>("mismatches");

            }

        }
    }

}