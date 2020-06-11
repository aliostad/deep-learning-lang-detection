using System.Collections.Generic;
using System.Linq;
using SFH.IT.Hljodrit.Common.Dto;
using SFH.IT.Hljodrit.Services.Interfaces;
using SFH.IT.Hljodrit.Repositories.Interfaces.Instruments;

namespace SFH.IT.Hljodrit.Services.Implementations
{
    public class InstrumentService : IInstrumentService
    {
        private readonly IInstrumentRepository _instrumentRepository;

        public InstrumentService(IInstrumentRepository instrumentRepository)
        {
            _instrumentRepository = instrumentRepository;
        }

        public IEnumerable<InstrumentDto> GetAllInstruments()
        {
            return _instrumentRepository.GetAll().Select(instrument => new InstrumentDto
            {
                IdCode = instrument.code,
                InstrumentNameEnglish = instrument.name_en,
                InstrumentNameIcelandic = instrument.name_is,
                DescriptionInIcelandic = instrument.description_is
            }).OrderBy(instrument => instrument.InstrumentNameIcelandic);
        }
    }
}
