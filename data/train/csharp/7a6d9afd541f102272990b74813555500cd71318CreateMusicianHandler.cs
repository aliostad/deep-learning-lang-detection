using System;
using MBB.Contracts.Musician.Create;
using MBB.Core.Musician.GeneralQueries;
using MBB.Infrastructure.Handling;

namespace MBB.Core.Musician.Create
{
    public class CreateMusicianHandler : IHandler<CreateMusicianCommand>
    {
        private readonly IInstrumentQuery _instrumentQuery;
        private readonly ISaveMusicianQuery _saveQuery;

        public CreateMusicianHandler(IInstrumentQuery instrumentQuery, ISaveMusicianQuery saveQuery)
        {
            _instrumentQuery = instrumentQuery;
            _saveQuery = saveQuery;
        }

        public void Handle(CreateMusicianCommand command)
        {


            var instrument = _instrumentQuery.Execute(command.InstrumentId);
            if (instrument == null)
                throw new ArgumentException("Invalid instrument");

            var newMusician = new Entities.Musician()
                {
                    Firstname = command.Firstname,
                    Surname = command.Surname,
                    Instrument = instrument
                };
            _saveQuery.Execute(newMusician);
        }
    }
}