using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using XMLSorting;

namespace XmlCrud
{
    class Program
    {
        static void Main(string[] args)
        {

            var band = new Band()
            {
                Name = "Pink Floyd",
                Vocalist = new Leader()
                {
                    Name = "Roger Waters"
                },
                Musicians = new List<Musician>()
                {
                    new Musician()
                    {
                        Name = "Sid Barret",
                        Instrument = new Instrument()
                        {
                            Name = "Electic-Guitar",
                            Type = InstrumentType.keyboard
                        }
                    },
                    new Musician()
                    {
                        Name = "Nick Mayson",
                        Instrument = new Instrument()
                        {
                            Name = "Drums",
                            Type = InstrumentType.drum
                        }
                    },
                    new Musician()
                    {
                        Name = "Richard Wright",
                        Instrument = new Instrument()
                        {
                            Name = "Electic-Piano",
                            Type = InstrumentType.keyboard
                        }
                    },
                }
            };

            XmlWorker worker = new XmlWorker();
            worker.Create(band);
            worker.Delete(new Musician()
            {
                Name = "Sid Barret",
                Instrument = new Instrument()
                {
                    Name = "Electic-Guitar",
                    Type = InstrumentType.keyboard
                }
            },
                band);
            worker.Update(new Musician()
            {
                Name = "David Gilmour",
                Instrument = new Instrument()
                {
                    Name = "Electic-Guitar",
                    Type = InstrumentType.keyboard
                }

            }, band);
            band = worker.Read();
            band.Info();
            Console.ReadKey();
        }
    }
}
