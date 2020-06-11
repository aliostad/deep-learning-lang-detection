using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SimpleFactory
{
    /// <summary>
    /// 具象クラスのインスタンスを生成するFactoryクラスです。
    /// </summary>
    public class InstrumentFactory
    {
        /// <summary>
        /// 楽器を生成します
        /// </summary>
        public IInstrument CreateInstrument(Instrument.InstrumentEnum instrument)
        {
            switch(instrument)
            {
                case Instrument.InstrumentEnum.Piano:
                    return new Instrument.Piano();
                case Instrument.InstrumentEnum.Flute:
                    return new Instrument.Flute();
                default:
                    throw new ArgumentException();
            }
        }
    }
}
