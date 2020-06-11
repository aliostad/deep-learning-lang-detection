using System.Collections.Generic;
using System.Linq;
using TrouveUnBand.Models;

namespace TrouveUnBand.Classes
{
    public static class CreateProfile
    {
        private static TrouveUnBandEntities db = new TrouveUnBandEntities();

        public static MusicianProfileViewModel CreateMusicianProfileView(User user)
        {
            
            var musicianList = new List<User>();
            musicianList.Add(user);
            var instrumentInfos = SetMusician_Instrument(musicianList);
            var musicianView = new MusicianProfileViewModel
            {
                InstrumentInfo = instrumentInfos[0],
                Description = user.Description,
                Name = user.FirstName + " " + user.LastName,
                Location = user.Location,
                Photo = user.Photo,
                Id = user.User_ID
            };

            return musicianView;
        }

        public static BandProfileViewModel CreateBandProfileView(Band band)
        {
            var bandView = new BandProfileViewModel
            {
                InstrumentInfoList = SetMusician_Instrument(band.Users.ToList()),
                Name = band.Name,
                Description = band.Description,
                Location = band.Location,
                Photo = "/Photos/_StockPhotos/_stock_band.jpg",
                id = band.Band_ID,
                Sc_Name = band.SC_Name,
                Genres = band.Genres,
                Events = band.Events
            };

            return bandView;
        }

        private static List<Musician_Instrument> SetMusician_Instrument(List<User> musicians)
        {
            var instrumentInfoList = new List<Musician_Instrument>();
            ICollection<Users_Instruments> listOfInstruments;
            var skillList = new List<string> { "Aucun", "Débutant", "Initié", "Intermédiaire", "Avancé", "Professionnel" };

            foreach (var musician in musicians)
            {
                listOfInstruments = musician
                                    .Users_Instruments
                                    .OrderByDescending(x => (x.Skills))
                                    .ToList();

                var instrumentInfo = new Musician_Instrument();

                foreach (var instrument in listOfInstruments)
                {
                    instrumentInfo.InstrumentNames
                       .Add(instrument.Instrument.Name);

                    instrumentInfo.Skills
                        .Add(skillList[instrument.Skills]);
                }
                instrumentInfoList.Add(instrumentInfo);
            }

            return instrumentInfoList;
        }
    }
}
