using System.Collections.Generic;
using System.Linq;
using Musicfy.Bll.Contracts;
using Musicfy.Bll.Mappers;
using Musicfy.Bll.Models;
using Musicfy.Dal.Contracts;
using Musicfy.Infrastructure.Exceptions;
using Musicfy.Infrastructure.Resources;
using Musicfy.Infrastructure.Utils;

namespace Musicfy.Bll.Services
{
    public class InstrumentService : IInstrumentService
    {
        private readonly IInstrumentRepository _instrumentRepository;

        public InstrumentService(IInstrumentRepository instrumentRepository)
        {
            _instrumentRepository = instrumentRepository;
        }

        public IEnumerable<InstrumentModel> GetAll()
        {
            var instruments = _instrumentRepository.GetAll();

            return instruments.Select(InstrumentMapper.ToInstrumentModel);
        }

        public InstrumentModel GetById(string id)
        {
            var instrument = _instrumentRepository.GetById(id);
            if (instrument == null)
            {
                throw new NotFoundException(Messages.InvalidInstrumentId);
            }

            return InstrumentMapper.ToInstrumentModel(instrument);
        }

        public void Add(InstrumentModel instrumentModel)
        {
            if (string.IsNullOrEmpty(instrumentModel.Name))
            {
                throw new ValidationException(Messages.InstrumentNameRequired);
            }

            var instrumentByName = _instrumentRepository.GetByName(instrumentModel.Name);
            if (instrumentByName != null)
            {
                throw new ConflictException(Messages.InstrumentNameAlreadyExists);
            }

            var instrument = InstrumentMapper.ToInstrument(instrumentModel);
            instrument.Id = SecurityUtils.GenerateEntityId();

            _instrumentRepository.Add(instrument);
        }

        public void Update(string id, InstrumentModel instrumentModel)
        {
            if (string.IsNullOrEmpty(instrumentModel.Name))
            {
                throw new ValidationException(Messages.InstrumentNameRequired);
            }

            var instrument = _instrumentRepository.GetById(id);
            if (instrument == null)
            {
                throw new NotFoundException(Messages.InvalidInstrumentId);
            }

            var instrumentByName = _instrumentRepository.GetByName(instrument.Name);
            if (instrumentByName != null && instrumentByName.Id != id)
            {
                throw new ConflictException(Messages.InstrumentNameAlreadyExists);
            }

            InstrumentMapper.RefreshInstrument(instrument, instrumentModel);
            _instrumentRepository.Update(instrument);
        }

        public void Delete(string id)
        {
            var instrument = _instrumentRepository.GetById(id);
            if (instrument == null)
            {
                throw new NotFoundException(Messages.InvalidInstrumentId);
            }

            _instrumentRepository.Delete(id);
        }
    }
}