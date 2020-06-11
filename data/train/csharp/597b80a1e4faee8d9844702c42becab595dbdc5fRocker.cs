
namespace CantAffordToRock.CoreGame
{
    public class Rocker
    {
        public Instrument Instrument { get; }
        public string Name { get; }
        public int Charisma { get; }
        public int Talent { get; }
        public int Opportunism { get; }

        public Rocker(Instrument instrument, string name, int charisma, int talent, int opportunism)
        {
            Instrument = instrument;
            Name = name;
            Talent = talent;
            Charisma = charisma;
            Opportunism = opportunism;
        }
    }
}
