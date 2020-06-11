using NetCoreTemplate.DataAccess.Contracts;
using NetCoreTemplate.DataAccess.Contracts.Repositories;

namespace NetCoreTemplate.DataAccess.EF
{
    public class RepositoryContext : IRepositoriesContext
    {
        public IPhoneRepository PhoneRepository { get; set; }

        public IAddressRepository AddressRepository { get; set; }

        public RepositoryContext(IPhoneRepository phoneRepository, IAddressRepository addressRepository)
        {
            PhoneRepository = phoneRepository;
            AddressRepository = addressRepository;
        }
    }
}