using System.Collections.Generic;

namespace MyGuitarLocker.Models
{
    public interface IMyGuitarLockerRepository
    {
        IEnumerable<object> GetAllUsers();
        IEnumerable<Instrument> GetAllInstruments();
        IEnumerable<Instrument> GetAllInstrumentsWithSoundClips();
        IEnumerable<Instrument> GetUserInstruments(string name);
        Instrument GetInstrumentByName(string InstrumentName, string userName);
        void AddInstrument(Instrument newInstrument);
        void AddSoundClip(string InstrumentName, SoundClip newSoundClip, string userName);
        void AddImage(string instrumentName, Image newImage, string userName);
        bool SaveAll();
    }
}