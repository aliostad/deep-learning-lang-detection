using System.ComponentModel.DataAnnotations;

namespace Playground.EF.App.Models
{
    public class SoloArtist : Artist
    {
        [StringLength(250, ErrorMessage = "The Instrument must be less than 250 characters in lenght")]
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
