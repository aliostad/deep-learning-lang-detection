
using System.Collections.Generic;



namespace EZSpreader
{
    public class Session
    {
        // This is a singleton
        private static Session instance = null;
        
        public List<Instrument> instruments = null;
        public Instrument instrumentA;
        public Instrument instrumentB;        
        public Spread spread;        


        public Session()
        {           
            spread = new Spread();
            instrumentA = new Instrument();
            instrumentB = new Instrument();

            instruments = new List<Instrument>();
            instruments.Add(instrumentA);
            instruments.Add(instrumentB);
        }

        static public Session getInstance()
        {
            if (instance == null)
                instance = new Session();

            return instance;
        }
        
    }
}
