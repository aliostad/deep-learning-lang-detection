namespace Playground.EF.App.Fluent.Models
{
    public class SoloArtist : Artist
    {
        public string Instrument { get; protected set; }

        protected SoloArtist() { }

        protected SoloArtist(Address address, string name, string nickname, string instrument) : base(name, address, nickname)
        {
            this.Instrument = instrument;
        }

        public static SoloArtist Generate(string name, Address address, string nickName = null, string instrument = "Guitar")
        {
            return new SoloArtist(address, name, nickName, instrument);
        }
    }
}
