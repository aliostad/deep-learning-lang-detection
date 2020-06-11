using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DeltaStore
{
    public class Manager
    {

        public List<Instrument> Instruments { get; set; }

        public Manager()
        {
            Instruments = new List<Instrument>()
            {
                new Instrument { Name = "Guitar", Inventory = 2 },
                new Instrument { Name = "Bass",   Inventory = 3 },
                new Instrument { Name = "Piano",  Inventory = 5 }
            };
        }

        public void AddInstrument()
        {
            Instrument newInstrument = new Instrument();

            List<string> instrumentNames = Instruments
                .Select(x => x.Name)
                .ToList();

            newInstrument.Name = ValidInput.Name(instrumentNames);

            if (String.IsNullOrEmpty(newInstrument.Name))
            {
                Console.WriteLine("Invalid input, operation aborted.");
                return;
            }

            try
            {
                Console.Write("Inventory: ");
                newInstrument.Inventory = int.Parse(Console.ReadLine());
            }
            catch (Exception)
            {
                Console.WriteLine("Invalid input, operation aborted.");
                return;
            }

            Instruments.Add(newInstrument);

            Console.WriteLine("Instrument added!");
        }
    }
}
