using DbLogic.Repositories.Interfaces;

namespace DbLogic
{
    public class DataManager
    {
        public DataManager(
            IComputerRepository computerRepository, 
            IManufacturerRepository manufacturerRepository,
            IUserRepository userRepository)
        {
            _computerRepository = computerRepository;
            _manufacturerRepository = manufacturerRepository;
            _userRepository = userRepository;
        }

        public IComputerRepository ComputerRepositories { get { return _computerRepository; } }
        public IManufacturerRepository ManufacturerRepositories { get { return _manufacturerRepository; } }
        public IUserRepository UserRepositories { get { return _userRepository; } }

        private readonly IComputerRepository _computerRepository;
        private readonly IManufacturerRepository _manufacturerRepository;
        private readonly IUserRepository _userRepository;
    }
}
