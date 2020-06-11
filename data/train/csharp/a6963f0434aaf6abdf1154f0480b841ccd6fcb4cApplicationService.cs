using RepositoryServices.Interfaces;
using RepositoryServices.Repositories;

namespace RepositoryServices
{
    public class ApplicationService
    {

        public ApplicationService(IUserRepository userRepository, IMachineRepository machineRepository, ISettingsRepository settingsRepository)
        {
            SettingsRepository = settingsRepository;
            UserRepository = userRepository;
            MachineRepository = machineRepository;
        }

        public IUserRepository UserRepository { get; set; }


        public IMachineRepository MachineRepository { get; set; }


        public ISettingsRepository SettingsRepository { get; set; }

    }
} 