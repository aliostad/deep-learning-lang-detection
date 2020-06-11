using AbstractFactory.MusicalInstruments.Abstract_Classes;
using AbstractFactory.MusicalInstruments.Concrete_Classes.ClassificationsFactory_Implementations;
using AbstractFactory.MusicalInstruments.Concrete_Classes.Instrument_Extensions;
using AbstractFactory.MusicalInstruments.Interfaces;

namespace AbstractFactory.MusicalInstruments.Concrete_Classes.InstrumentFactory_Extensions {
    class ModernInstrumentFactory : InstrumentFactory {
        public override Instrument CreateInstrument(string type) {
            Instrument instrument = null;
            ClassificationsFactory factory = new ModernClassificationsFactory();
            switch (type) {
                case "string": {
                        instrument = new StringInstrument(factory); //only one instrument; good enough for this practice project
                        instrument._Name = "Electric Guitar";
                        break;
                    }
                default: return null;
            }

            return instrument;
        }
    }
}