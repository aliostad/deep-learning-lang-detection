using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reactive.Subjects;
using System.Timers;


namespace InstrumentMonitor
{
    /// <summary>
    /// The PricingService class works as the simulation engine as defined in the instrument monitor requirements.
    /// All Quote data can be accessed by listening to the Quotes subject. Bloomberg and Reuters work as my fictional
    /// price feeds.
    /// The list of available instruments is also available from this class.
    /// </summary>
    public class PricingService
    {
        #region Private Members
        private Subject<Quote> _quoteSubject = new Subject<Quote>();
        private List<Instrument> _intruments { get; set; }
        private Timer _quoteTimerReuters;
        private Timer _quoteTimerBloomberg;
        private Random _random = new Random();
        #endregion

        #region Public Members
        public IObservable<Quote> Quotes { get; private set; }  
        #endregion

        #region Public Methods
        public List<Instrument> GetInstuments()
        {
            return _intruments;
        }

        public void StartReutersFeed()
        {
            _quoteTimerReuters = new Timer(100);
            _quoteTimerReuters.Elapsed += new ElapsedEventHandler(_quoteTimerReuters_Elapsed);
            _quoteTimerReuters.Start();
        }

        public void StopReutersFeed()
        {
            _quoteTimerReuters.Stop();
        }

        public void StartBloombergFeed()
        {
            _quoteTimerBloomberg = new Timer(100);
            _quoteTimerBloomberg.Elapsed += new ElapsedEventHandler(_quoteTimerBloomberg_Elapsed);
            _quoteTimerBloomberg.Start();
        }

        public void StopBloommbergFeed()
        {
            _quoteTimerBloomberg.Stop();
        }
        #endregion

        #region Private Methods
        private void _quoteTimerReuters_Elapsed(object sender, ElapsedEventArgs e)
        {
            Quote quote = new Quote();

            quote.Bid = GetPrice();
            quote.Ask = Math.Round(quote.Bid * 1.02, 2);
            quote.Price = (quote.Ask + quote.Bid) / 2;
            quote.PriceSource = "Reuters";
            quote.InstrumentID = _random.Next(1, 12);

            _quoteSubject.OnNext(quote);
        }

        private void _quoteTimerBloomberg_Elapsed(object sender, ElapsedEventArgs e)
        {
            Quote quote = new Quote();

            quote.Bid = GetPrice();
            quote.Ask = Math.Round(quote.Bid * 1.02, 2);
            quote.Price = (quote.Ask + quote.Bid) / 2;
            quote.PriceSource = "Bloomberg";
            quote.InstrumentID = _random.Next(1, 12);

            _quoteSubject.OnNext(quote);
        }

        private double GetPrice()
        {
            double factor = 100 * 0.1 * _random.NextDouble();
            factor = _random.NextDouble() > 0.5 ? factor : -factor;
            double price = 100 + factor;
            return Math.Round(price, 2);
        }

        private void PopulateSymbols()
        {
            _intruments = new List<Instrument>();

            _intruments.Add(new Instrument() { InstrumentID = 1, InstrumentName = "ICE" });
            _intruments.Add(new Instrument() { InstrumentID = 2, InstrumentName = "XOM" });
            _intruments.Add(new Instrument() { InstrumentID = 3, InstrumentName = "CVX" });
            _intruments.Add(new Instrument() { InstrumentID = 4, InstrumentName = "PG" });
            _intruments.Add(new Instrument() { InstrumentID = 5, InstrumentName = "MMM" });
            _intruments.Add(new Instrument() { InstrumentID = 6, InstrumentName = "JNJ" });
            _intruments.Add(new Instrument() { InstrumentID = 7, InstrumentName = "MCD" });
            _intruments.Add(new Instrument() { InstrumentID = 8, InstrumentName = "WMT" });
            _intruments.Add(new Instrument() { InstrumentID = 9, InstrumentName = "MRK" });
            _intruments.Add(new Instrument() { InstrumentID = 10, InstrumentName = "IBM" });
            _intruments.Add(new Instrument() { InstrumentID = 11, InstrumentName = "HOG" });

        }
        #endregion

        #region Constructors

        public PricingService()
        {
            Quotes = _quoteSubject;
            PopulateSymbols();
        }

        #endregion
               
    }
}
