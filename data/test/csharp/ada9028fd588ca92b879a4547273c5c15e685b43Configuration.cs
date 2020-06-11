namespace WadsworthBand.Migrations
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Migrations;
    using System.Linq;
    using WadsworthBand.Models;
    using WadsworthBand.Common;

    internal sealed class Configuration : DbMigrationsConfiguration<WadsworthBand.Models.WBDbContext>
    {
        public Configuration()
        {
            AutomaticMigrationsEnabled = false;
        }

        protected override void Seed(WadsworthBand.Models.WBDbContext context)
        {
            //  This method will be called after migrating to the latest version.

            //  You can use the DbSet<T>.AddOrUpdate() helper extension method 
            //  to avoid creating duplicate seed data. E.g.
            //
            //    context.People.AddOrUpdate(
            //      p => p.FullName,
            //      new Person { FullName = "Andrew Peters" },
            //      new Person { FullName = "Brice Lambson" },
            //      new Person { FullName = "Rowan Miller" }
            //    );
            //

            UserManager.CreateUser("Hadgis", "theHadge2015");
            UserManager.CreateUser("Hire", "dana2015");
            UserManager.CreateUser("BandBoosters", "boosters2015");

            context.MarchingInstruments.AddOrUpdate(m => m.InstrumentName,
                new MarchingInstrument { InstrumentName = "Drum Major" },
                new MarchingInstrument { InstrumentName = "Flute" },
                new MarchingInstrument { InstrumentName = "Clarinet" },
                new MarchingInstrument { InstrumentName = "Alto Sax" },
                new MarchingInstrument { InstrumentName = "Tenor Sax" },
                new MarchingInstrument { InstrumentName = "Bari Sax" },
                new MarchingInstrument { InstrumentName = "Horn" },
                new MarchingInstrument { InstrumentName = "Baritone" },
                new MarchingInstrument { InstrumentName = "Tuba" },
                new MarchingInstrument { InstrumentName = "Trumpet" },
                new MarchingInstrument { InstrumentName = "Trombone" },
                new MarchingInstrument { InstrumentName = "Percussion" },
                new MarchingInstrument { InstrumentName = "Color Guard" }
            );

            context.ConcertInstruments.AddOrUpdate(m => m.InstrumentName,
                new ConcertInstrument { InstrumentName = "Flute" },
                new ConcertInstrument { InstrumentName = "Clarinet" },
                new ConcertInstrument { InstrumentName = "Bass Clarinet" },
                new ConcertInstrument { InstrumentName = "Oboe" },
                new ConcertInstrument { InstrumentName = "Bassoon" },
                new ConcertInstrument { InstrumentName = "Alto Sax" },
                new ConcertInstrument { InstrumentName = "Tenor Sax" },
                new ConcertInstrument { InstrumentName = "Bari Sax" },
                new ConcertInstrument { InstrumentName = "Trumpet" },
                new ConcertInstrument { InstrumentName = "Euphonium" },
                new ConcertInstrument { InstrumentName = "Horn" },
                new ConcertInstrument { InstrumentName = "Trombone" },
                new ConcertInstrument { InstrumentName = "Tuba" },
                new ConcertInstrument { InstrumentName = "Percussion" }
            );
        }
    }
}
