using System;

namespace DesignPatterns.Creational.Factory
{
    class Factory : IRunnable
    {
        public void Run()
        {
            Console.WriteLine("--Factory pattern--\n");

            var factory = new InstrumentFactory();

            var violin = factory.GetInstrument(InstrumentType.Violin);
            violin.Play();

            var piano =  factory.GetInstrument(InstrumentType.Piano);
            piano.Play();

            var guitar =  factory.GetInstrument(InstrumentType.Guitar);
            guitar.Play();

            Console.WriteLine();
        }
    }
}
