using OOADExercise.Exercise_2;
using OOADExercise.Exercise_2.Enums;
using OOADExercise.Exercise_2_4___RicksGuitarInventory;
using System;
using System.Collections.Generic;
using System.Linq;

namespace OOADExercise
{
    class RicksStore
    {
        public void RunSimulator()
        {
            // Guitar Customer
            // Setup Rick's Guitar inventory
            Inventory inventory = new Inventory();

            inventory = initializeInventory(inventory);

            Dictionary<string, object> properties = new Dictionary<string, object>();

            properties.Add("builder", Builder.GIBSON);
            properties.Add("backWood", Wood.MAPLE);

            InstrumentSpec clientSpec = new InstrumentSpec(properties);

            List<Instrument> matchingInstruments = inventory.search(clientSpec);

            if (matchingInstruments.Any())
            {
                foreach (Instrument instrument in matchingInstruments)
                {

                    InstrumentSpec instrumentSpec = instrument.getSpec();
                    Console.WriteLine("We have a {0} with the following properties:", instrumentSpec.getProperty("instrumentType"));

                    var specProperties = instrumentSpec.getProperties();
                    foreach (string property in specProperties.Keys)
                    {
                        if (property.Equals("instrumentType"))
                            continue;
                        Console.WriteLine("{0}: {1}", property, instrumentSpec.getProperty(property));
                    }
                    Console.WriteLine("You can have this {0} for ${1}", instrumentSpec.getProperty("instrumentType"), instrument.getPrice());
                    Console.WriteLine("---------------------------");
                }
            }
            else
                Console.WriteLine("Sorry customer, we don't have anything for you.");

        }

        private static Inventory initializeInventory(Inventory inventory)
        {
            string[] keys = {"instrumentType", "builder", "model", "type", "numStrings", "topWood", "backWood"};

            Dictionary<string, object> properties = new Dictionary<string, object>();
            properties.Add("instrumentType", InstrumentType.GUITAR);
            properties.Add("builder", Builder.COLLINGS);
            properties.Add("model", "CJ");
            properties.Add("type", PlayType.ACOUSTIC);
            properties.Add("numStrings", 6);
            properties.Add("topWood", Wood.INDIAN_ROSEWOOD);
            properties.Add("backWood", Wood.SITKA);
            InstrumentSpec instrumentSpec = new InstrumentSpec(properties);
            inventory.addInstrument("11277", 3999.95, instrumentSpec);

            properties["builder"] = Builder.MARTIN;
            properties["model"] = "D-18";
            properties["topWood"] = Wood.MAHOGANY;
            properties["backWood"] = Wood.ADIRONDACK;
            inventory.addInstrument("122784", 5495.95, new InstrumentSpec(properties));

            properties["builder"] = Builder.FENDER;
            properties["model"] = "Stratocastor";
            properties["type"] = PlayType.ELECTRIC;
            properties["topWood"] = Wood.ALDER;
            properties["backWood"] = Wood.ALDER;

            inventory.addInstrument("V95693", 1499.95, new InstrumentSpec(properties));
            inventory.addInstrument("V9512", 1549.95, new InstrumentSpec(properties));

            properties["builder"] = Builder.GIBSON;
            properties["model"] = "Les Paul";
            properties["topWood"] = Wood.MAPLE;
            properties["backWood"] = Wood.MAPLE;
            inventory.addInstrument("70108276", 2295.95, new InstrumentSpec(properties));

            properties["model"] = "SG '61 Reissue";
            properties["topWood"] = Wood.MAHOGANY;
            properties["backWood"] = Wood.MAHOGANY;
            inventory.addInstrument("82765501", 1890.95, new InstrumentSpec(properties));

            properties["instrumentType"] = InstrumentType.MANDOLIN;
            properties["type"] = PlayType.ACOUSTIC;
            properties["model"]= "F-5G";
            properties["backWood"]= Wood.MAPLE;
            properties["topWood"]= Wood.MAPLE;
            properties.Remove("numStrings");
            inventory.addInstrument("9019920", 5495.99, new InstrumentSpec(properties));

            properties["instrumentType"] = InstrumentType.BANJO;
            properties["model"] = "RB-3 Wreath";
            properties.Remove("topWood");
            properties.Add("numStrings", 5);
            inventory.addInstrument("8900231", 2945.95, new InstrumentSpec(properties));

            return inventory;
        }
    }
}
