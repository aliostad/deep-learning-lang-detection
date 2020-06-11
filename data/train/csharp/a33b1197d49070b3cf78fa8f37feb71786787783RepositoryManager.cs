using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace IGSoft.CarPack.Mobile.Repository
{
    public class RepositoryManager : IRepositoryManager
    {
        private readonly ICompanyRepository _companyRepository;
        private readonly IRecordRepository _recordRepository;
        private readonly IExpertRepository _expertRepository;
        private readonly IPhotoRepository _photoRepository;

        public RepositoryManager(ICompanyRepository companyRepository,
            IRecordRepository recordRepository,
            IExpertRepository expertRepository,
            IPhotoRepository photoRepository)
        {
            _companyRepository = companyRepository;
            _recordRepository = recordRepository;
            _expertRepository = expertRepository;
            _photoRepository = photoRepository;
        }

        public async Task Initialize()
        {
            await _companyRepository.Load();
            await _recordRepository.Load();
            await _expertRepository.Load();
            await _photoRepository.Load();
        }

        public async Task Save()
        {
            await _companyRepository.Save(true);
            await _recordRepository.Save(true);
            await _expertRepository.Save();
            await _photoRepository.Save();
        }
    }
}
