using System;
using System.Collections.Generic;
using System.Data.Entity;
using TheGapFillers.Portrack.Models.Application;
using TheGapFillers.Portrack.Repositories.Application.EF.Mappers;

namespace TheGapFillers.Portrack.Repositories.Application.EF.Contexts
{
    public class ApplicationDbContext : DbContext, IApplicationDbContext
    {
        public ApplicationDbContext()
            : base("ApplicationConnection")
        {
            Configuration.LazyLoadingEnabled = false;                                               // Disable lazy loading for all db sets.
            Database.SetInitializer(new ApplicationDbContextInitializer());   // No code first initialisation.
        }

        public DbSet<Portfolio> Portfolios { get; set; }
        public DbSet<Holding> Holdings { get; set; }
        public DbSet<Transaction> Transactions { get; set; }
        public DbSet<Instrument> Instruments { get; set; }


        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Properties<DateTime>().Configure(c => c.HasColumnType("datetime2"));

            modelBuilder.Configurations.Add(new PortfolioMap());
            modelBuilder.Configurations.Add(new HoldingMap());
            modelBuilder.Configurations.Add(new TransactionMap());
            modelBuilder.Configurations.Add(new InstrumentMap());
        }
    }

    public class ApplicationDbContextInitializer : DropCreateDatabaseIfModelChanges<ApplicationDbContext>
    {
        protected override void Seed(ApplicationDbContext context)
        {
            var instruments = new List<Instrument>
            {
                // Currencies
                new Instrument { Type = InstrumentType.Fx, Ticker = "USD"     , Name = "US Dollar"        , Currency = "USD" },
                new Instrument { Type = InstrumentType.Fx, Ticker = "EUR"     , Name = "Euro"             , Currency = "EUR" },
                new Instrument { Type = InstrumentType.Fx, Ticker = "CNY"     , Name = "Chinese Yuan"     , Currency = "CNY" },
                new Instrument { Type = InstrumentType.Fx, Ticker = "HKD"     , Name = "Hong Kong Dollar" , Currency = "HKD" },

                // Exchange List
                new Instrument { Type = InstrumentType.Exchange, Ticker = ""        , Name = "US Exchange"          , Currency = "USD" },
                new Instrument { Type = InstrumentType.Exchange, Ticker = ".PA"     , Name = "Paris Exchange"       , Currency = "EUR" },
                new Instrument { Type = InstrumentType.Exchange, Ticker = ".DE"     , Name = "German Exchange"      , Currency = "EUR" },
                new Instrument { Type = InstrumentType.Exchange, Ticker = ".SH"     , Name = "Shanghai Exchange"    , Currency = "CNY" },
                new Instrument { Type = InstrumentType.Exchange, Ticker = ".HK"     , Name = "Hong Kong Exchange"   , Currency = "HKD" },

                // US Stocks
                new Instrument { Type = InstrumentType.Stock, Ticker = "GOOG"    , Name = "Google"           , Currency = "USD" },
                new Instrument { Type = InstrumentType.Stock, Ticker = "YHOO"    , Name = "Yahoo"            , Currency = "USD" },
                new Instrument { Type = InstrumentType.Stock, Ticker = "MSFT"    , Name = "Microsoft"        , Currency = "USD" },
                new Instrument { Type = InstrumentType.Stock, Ticker = "AAPL"    , Name = "Apple"            , Currency = "USD" },

                // Euro Stocks
                new Instrument { Type = InstrumentType.Stock, Ticker = "MC.PA"   , Name = "LVMH"             , Currency = "EUR" },
                new Instrument { Type = InstrumentType.Stock, Ticker = "ALV.DE"  , Name = "Allianz"          , Currency = "EUR" },

                // Hong Kong Stocks
                new Instrument { Type = InstrumentType.Stock, Ticker = "0004.HK" , Name = "Wharf"            , Currency = "HKD" },
                new Instrument { Type = InstrumentType.Stock, Ticker = "0005.HK" , Name = "HSBC"             , Currency = "HKD" },
            };

            context.Instruments.AddRange(instruments);
            context.SaveChanges();

            base.Seed(context);
        }
    }
}