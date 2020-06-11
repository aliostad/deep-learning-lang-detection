using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RicksGuitarsStart.Model
{
    class Inventory
    {
        private List<Instrument> instruments = new List<Instrument>();

        public ICollection<string> Models
        {
            get
            {
                List<string> models = new List<string>();
                foreach (Instrument instrument in instruments)
                {
                    string model = instrument.Specification.GetProperty("Model") as string;
                    if (!models.Contains(model))
                        models.Add(model);
                }
                models.Sort();
                return models;
            }
        }

        public ICollection<string> InstrumentTypes
        {
            get
            {
                List<string> instrumentTypes = new List<string>();
                foreach (Instrument instrument in instruments)
                {
                    string instrumentType = ((InstrumentType)instrument.Specification.GetProperty("InstrumentType")).ToString();
                    if (!instrumentTypes.Contains(instrumentType))
                        instrumentTypes.Add(instrumentType);
                }
                instrumentTypes.Sort();
                return instrumentTypes;
            }
        }

        /// <summary>
        /// Initialize the inventory.
        /// </summary>
        public void Initialize()
        {
            Dictionary<string, object> properties = new Dictionary<string, object>
            {
                { "InstrumentType", InstrumentType.Guitar },
                { "Builder", Builder.Collings },
                { "Model", "CJ" },
                { "Category", Category.Acoustic },
                { "NumberOfStrings", 6 },
                { "TopWood", Wood.IndianRosewood },
                { "BackWood", Wood.Sitka }
            };
            Add(new Instrument("11277", 3999.95m, new InstrumentSpecification(properties)));

            properties["Builder"] = Builder.Martin;
            properties["Model"] = "D-18";
            properties["TopWood"] = Wood.Mahogany;
            properties["BackWood"] = Wood.Adirondack;
            Add(new Instrument("122784", 5495.95m, new InstrumentSpecification(properties)));

            properties["Builder"] = Builder.Fender;
            properties["Model"] = "Stratocastor";
            properties["Category"] = Category.Electric;
            properties["TopWood"] = Wood.Alder;
            properties["BackWood"] = Wood.Alder;
            Add(new Instrument("V95693", 1499.95m, new InstrumentSpecification(properties)));
            Add(new Instrument("V9512", 1549.95m, new InstrumentSpecification(properties)));

            properties["Builder"] = Builder.Gibson;
            properties["Model"] = "Les Paul";
            properties["TopWood"] = Wood.Maple;
            properties["BackWood"] = Wood.Maple;
            Add(new Instrument("70108276", 2295.95m, new InstrumentSpecification(properties)));

            properties["Model"] = "SG '61 Reissue";
            properties["TopWood"] = Wood.Mahogany;
            properties["BackWood"] = Wood.Mahogany;
            Add(new Instrument("82765501", 1890.95m, new InstrumentSpecification(properties)));

            properties["InstrumentType"] = InstrumentType.Mandolin;
            properties["Category"] = Category.Acoustic;
            properties["Model"] = "F-5G";
            properties["BackWood"] = Wood.Maple;
            properties["TopWood"] = Wood.Maple;
            properties.Remove("NumberOfStrings");
            properties["Style"] = Style.F;
            Add(new Instrument("9019920", 5495.99m, new InstrumentSpecification(properties)));

            properties["InstrumentType"] = InstrumentType.Banjo;
            properties["Model"] = "RB-3 Wreath";
            properties.Remove("TopWood");
            properties["NumberOfStrings"] = 5;
            properties.Remove("Style");
            Add(new Instrument("8900231", 2945.95m, new InstrumentSpecification(properties)));
        }

        /// <summary>
        /// Add an Instrument to the inventory.
        /// </summary>
        /// <param name="InstrumentType">The Instrument to add to the inventory.</param>
        public void Add(Instrument instrument)
        {
            if (instrument is null)
                throw new ArgumentNullException(nameof(instrument));
            instruments.Add(instrument);
        }

        /// <summary>
        /// Search for an Instrument like the one given as a parameter.
        /// </summary>
        /// <param name="searchGuitar">The Guitar to searcvh for.</param>
        /// <returns>A collection of all the guitars that match the criteria.</returns>
        public ICollection<Instrument> Search(InstrumentSpecification searchSpecification)
        {
            if (searchSpecification is null)
                throw new ArgumentNullException(nameof(searchSpecification));

            List<Instrument> foundInstruments = new List<Instrument>();
            foreach (Instrument instrument in instruments)
            {
                if (instrument.Specification.Matches(searchSpecification))
                    foundInstruments.Add(instrument);
            }
            return foundInstruments;
        }
    }
}
