using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using TraderClient.TypeExtensions;

namespace TraderClient.OrderBLL
{
    internal sealed class Instrument
    {
        internal Instrument(XElement element)
        {
            this.Id = Guid.Parse(element.ParseContent("ID"));
            this.Code = element.ParseContent("Code");
            int category = int.Parse(element.ParseContent("Category"));
            this.IsPhysical = category == 20 ;
        }

        internal Guid Id { get; private set; }

        internal string Code { get; private set; }

        internal bool IsPhysical { get; private set; }

    }


    internal sealed class InstrumentManager
    {
        internal static readonly InstrumentManager Default = new InstrumentManager();

        private Dictionary<Guid, Instrument> _instrumentDict = new Dictionary<Guid, Instrument>();

        static InstrumentManager() { }
        private InstrumentManager() { }

        internal void Initialize()
        {
            foreach (var eachElement in Settings.Default.SettingElement.Elements("Instrument"))
            {
                Guid id = Guid.Parse(eachElement.ParseContent("ID"));
                if (!_instrumentDict.ContainsKey(id))
                {
                    var instrument = new Instrument(eachElement);
                    _instrumentDict.Add(id, instrument);
                }
            }
        }

        internal Instrument GetInstrument(Guid instrumentId)
        {
            Instrument result;
            _instrumentDict.TryGetValue(instrumentId, out result);
            return result;
        }

    }


    internal sealed class Settings
    {
        private static readonly ILog Logger = LogManager.GetLogger(typeof(Settings));

        internal static readonly Settings Default = new Settings();

        static Settings() { }
        private Settings() { }

        internal XElement SettingElement { get; private set; }

        internal void Initialize()
        {
            try
            {
                this.SettingElement = XElement.Load(SettingManager.Default.SettingFilePath);
            }
            catch (Exception ex)
            {
                Logger.Error(ex);
            }
        }

    }


}
