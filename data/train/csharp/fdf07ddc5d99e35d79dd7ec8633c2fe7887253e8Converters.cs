/// Author: Thomas Diego Prananta, 2016
/// All rights reserved
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MusicalTracker.DAL.Interfaces;
using System.Diagnostics;
namespace MusicalTracker.DAL
{
    public class Converters
    {
        static public InstrumentType ConvertInstrTypeStrToEnum(string instrumentType)
        {
            Debug.Assert(false == string.IsNullOrEmpty(instrumentType));
            if(0==String.Compare(instrumentType, "World Instruments",true))
            {
                return InstrumentType.WorldInstruments;
            }
            return (InstrumentType) Enum.Parse(typeof(InstrumentType), instrumentType);

        }
        static public string ConvertInstrTypeEnumToString(InstrumentType type)
        {
      
            if (type == InstrumentType.WorldInstruments)
            {
                return "World Instruments";
            }
            return type.ToString();

        }

    }
}
