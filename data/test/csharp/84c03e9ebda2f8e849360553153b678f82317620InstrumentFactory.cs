using System;

namespace Screens.Instruments
{
    public class InstrumentFactory
    {
        public static Instrument Create(InstrumentType type)
        {
            switch (type)
            {
                case InstrumentType.Line:
                    return new LineInstrument();
                case InstrumentType.Pen:
                    return new PenInstrument();
                case InstrumentType.Rect:
                    return new RectInstrument(); 
                case InstrumentType.Arrow:
                    return new ArrowInstrument();
                case InstrumentType.Blur:
                    return new BlurInstrument();
                case InstrumentType.Hightlight:
                    return new HightlightInstrument();
                case InstrumentType.Text:
                    return new TextInstrument();
                case InstrumentType.Eraser:
                    return new EraserInstrument();
                default:
                    throw new NotImplementedException();
            }
        }
    }
}