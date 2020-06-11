using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Decorator
{

    public abstract class MusicInstrument 
    {
        public virtual void PlaySound()
        {
            Console.WriteLine("beep!");
        }
    } 

    public class Guitar:MusicInstrument
    {
        public override void PlaySound()
        {
            base.PlaySound();
            Console.WriteLine("Guitar sound!");
        }
    }

    public abstract  class Decorator:MusicInstrument
    {
        protected MusicInstrument _instrument;
        public Decorator(MusicInstrument instrument)
        {
            _instrument = instrument;
        }
        public MusicInstrument Instrument
        {
            get 
            {
                return _instrument;
            }
            set
            {
            if (value != null)
            {
                _instrument = value;
            }
        } }

        public bool SetInstrument(MusicInstrument instrument)
        {
             _instrument = instrument;
             return true;
        }

        public override void PlaySound()
        {
            _instrument.PlaySound();
        }
    }

    public class ElectroInstrument : Decorator
    {
        public ElectroInstrument(MusicInstrument instrument):base(instrument)
        {
        }

        public double Voltage { get; set; }
        public override void PlaySound()
        {
            base.PlaySound();
            for (int i = 0; i < Math.Sqrt(this.Voltage); ++i)
            {
                Console.WriteLine("~");
            }
        }
    }

    public class AcousticInstrument : Decorator
    {
        public AcousticInstrument(MusicInstrument instrument)
            : base(instrument)
        {
        }

        public double Tembr { get; set; }
        public override void PlaySound()
        {
            base.PlaySound();
            for (int i = 0; i < Math.Sqrt(this.Tembr); ++i)
            {
                Console.WriteLine("#");
            }
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            Guitar g = new Guitar();

            ElectroInstrument einstrument = new ElectroInstrument(g);
            einstrument.Voltage = 100;
            einstrument.PlaySound();

            AcousticInstrument ainstrument = new AcousticInstrument(g);
            ainstrument.Tembr = 100;
            ainstrument.PlaySound();

        }
    }
}
