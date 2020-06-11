using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BukkitNET
{

    public enum Instrument : byte
    {
        Piano = 0x0,
        BassDrum = 0x1,
        SnareDrum = 0x2,
        Sticks = 0x3,
        BassGuitar = 0x4
    }

    public static class InstrumentHelper
    {

        public static Instrument GetByType(byte type)
        {
            return (Instrument)type;
        }

    }

    public static class InstrumentExtensions
    {

        public static byte GetInstrumentType(this Instrument instrument)
        {
            return (byte)instrument;
        }

    }

}
