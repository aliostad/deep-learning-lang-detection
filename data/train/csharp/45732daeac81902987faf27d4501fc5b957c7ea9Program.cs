using System;
using System.Collections.Generic;


namespace InstrumentAppV2
{
	class MainClass
	{
		public static void Main (string[] args)
		{

			Inventory inventory = new Inventory ();
			initializeInventory(inventory);

			Dictionary<string,object> properties = new Dictionary<string,object>();
			properties.Add("builder", Builder.GIBSON);
			properties.Add("backWood", Wood.MAPLE);
			InstrumentSpec whatBryanLikes = new InstrumentSpec(properties);

			List<Instrument> matchingInstruments = inventory.search(whatBryanLikes);

			if (matchingInstruments.Count != 0) {
				Console.WriteLine ("Bryan, you might like these instruments:");
				foreach (Instrument instrument in matchingInstruments) {
					InstrumentSpec instrumentSpec = instrument.Spec;
					Console.WriteLine("  We have a " + instrumentSpec.getProperty("instrumentType") + " with the following properties:");
					foreach (KeyValuePair<string,object> kvproperty in instrumentSpec.getProperties()) {
						if (kvproperty.Key == "instrumentType")
							continue;
						Console.WriteLine("    " + kvproperty.Key + ": " + kvproperty.Value); 
					}
							Console.WriteLine("  You can have this " +
								instrumentSpec.getProperty("instrumentType") + " for $" + 
								instrument.Price + "\n---");
				}
			} else {
				Console.WriteLine("Sorry, Erin, we have nothing for you.");
			}
			Console.ReadKey();
		}


		private static void initializeInventory(Inventory inventory) {
			Dictionary<string,object> properties = new Dictionary<string,object>();
			properties.Add("instrumentType", InstrumentType.GUITAR);
			properties.Add("builder", Builder.COLLINGS);
			properties.Add("model", "CJ");
			properties.Add("type", Typeg.ACOUSTIC);
			properties.Add("numStrings", 6);
			properties.Add("topWood", Wood.INDIAN_ROSEWOOD);
			properties.Add("backWood", Wood.SITKA);
			inventory.addInstrument("11277", 3999.95, new InstrumentSpec(properties));

			properties["builder"] = Builder.MARTIN;
			properties["model"] = "D-18";
			properties["topWood"] = Wood.MAHOGANY;
			properties["backWood"] =  Wood.ADIRONDACK;
			inventory.addInstrument("122784", 5495.95, new InstrumentSpec(properties));

			properties["builder"] = Builder.FENDER;
			properties["model"] = "Stratocastor";
			properties["type"] = Typeg.ELECTRIC;
			properties["topWood"] = Wood.ALDER;
			properties["backWood"] = Wood.ALDER;
			inventory.addInstrument("V95693", 1499.95, new InstrumentSpec(properties));
			inventory.addInstrument("V9512", 1549.95, new InstrumentSpec(properties));

			properties["builder"] = Builder.GIBSON;
			properties["model"] =  "Les Paul";
			properties["topWood"] = Wood.MAPLE;
			properties["backWood"] =  Wood.MAPLE;
			inventory.addInstrument("70108276", 2295.95, new InstrumentSpec(properties));

			properties["model"] =  "SG '61 Reissue";
			properties["topWood"] = Wood.MAHOGANY;
			properties["backWood"] = Wood.MAHOGANY;
			inventory.addInstrument("82765501", 1890.95, new InstrumentSpec(properties));

			properties["instrumentType"] = InstrumentType.MANDOLIN;
			properties["type"] = Typeg.ACOUSTIC;
			properties["model"] = "F-5G";
			properties["backWood"] = Wood.MAPLE;
			properties["topWood"] = Wood.MAPLE;
			properties.Remove("numStrings");
			inventory.addInstrument("9019920", 5495.99, new InstrumentSpec(properties));

			properties["instrumentType"] =  InstrumentType.BANJO;
			properties["model"] = "RB-3 Wreath";
			properties.Remove("topWood");
			properties.Add("numStrings", 5);
			inventory.addInstrument("8900231", 2945.95, new InstrumentSpec(properties));
		}

	}
}
