using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class InstrumentHelper : UnitySingleton<InstrumentHelper>
{
    private List<Instrument> _instruments;
    
    public List<Instrument> Instruments
    {
        get
        {
            if (_instruments == null)
            {
                _instruments = new List<Instrument>(System.Enum.GetValues(typeof(Instrument)).Cast<Instrument>());
            }
            
            return _instruments;
        }
    }

    public static Color GetColorForInstrument(Instrument instrument)
    {
        switch (instrument)
        {
            case Instrument.Red:
                return Color.red;
            case Instrument.Orange:
                return new Color32(255, 69, 0, 255);
            case Instrument.Yellow:
                return Color.yellow;
            case Instrument.Green:
                return Color.green;
            case Instrument.Blue:
                return Color.blue;
            case Instrument.Purple:
                return new Color32(128, 0, 128, 255);
            default:
                Debug.LogError("No color found for: " + instrument.ToString());
                return Color.magenta;
        }
    }

    public static List<Instrument> GetInstrumentList()
    {
        return InstrumentHelper.Instance.Instruments;
    }
}