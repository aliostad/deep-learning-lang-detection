namespace SimpleFactory
{
    public class Program
    {
        private static InstrumentFactory _instrumentFactory = new InstrumentFactory();

        static void Main(string[] args)
        {
            IInstrument _instrument;

            //ピアノ生成
            _instrument = _instrumentFactory.CreateInstrument(Instrument.InstrumentEnum.Piano);
            System.Console.WriteLine(_instrument.Play());
            System.Console.WriteLine(_instrument.CanPortable() == true ? "持ち運べます。" : "持ち運べません！");

            //フルート生成
            _instrument = _instrumentFactory.CreateInstrument(Instrument.InstrumentEnum.Flute);
            System.Console.WriteLine(_instrument.Play());
            System.Console.WriteLine(_instrument.CanPortable() == true ? "持ち運べます。" : "持ち運べません！");

            System.Console.ReadLine();
        }
    }
}
