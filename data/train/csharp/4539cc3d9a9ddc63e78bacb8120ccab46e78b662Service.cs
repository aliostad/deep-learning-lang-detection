using CoreApiOnion.Api.Entities;
using CoreApiOnion.Api.Interfaces;

namespace CoreApiOnion.Api.Services
{
    public class Service : IService
    {
        private readonly IDatabaseRepository _databaseRepository;
        private readonly IExternalApiRepository _externalApiRepository;

        public Service(IDatabaseRepository databaseRepository, IExternalApiRepository externalApiRepository)
        {
            _databaseRepository = databaseRepository;
            _externalApiRepository = externalApiRepository;
        }
        
    }
}
