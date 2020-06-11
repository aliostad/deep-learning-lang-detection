using System;
using System.Linq;

namespace Roomie.Web.Persistence.Repositories
{
    public class CompositeImplementationRepositoryFactory : IRepositoryFactory
    {
        private IRepositoryFactory[] _repositoryFactories;

        private IComputerRepository _computerRepository;
        private IDeviceRepository _deviceRepository;
        private INetworkGuestRepository _networkGuestRepository;
        private INetworkRepository _networkRepository;
        private IScriptRepository _scriptRepository;
        private ISessionRepository _sessionRepository;
        private ITaskRepository _taskRepository;
        private IUserRepository _userRepository;
        
        public CompositeImplementationRepositoryFactory(params IRepositoryFactory[] repositoryFactories)
        {
            _repositoryFactories = repositoryFactories;
        }

        public IComputerRepository GetComputerRepository()
        {
            if (_computerRepository == null)
            {
                _computerRepository = GetRepository(x => x.GetComputerRepository());
            }

            return _computerRepository;
        }
        
        public IDeviceRepository GetDeviceRepository()
        {
            if (_deviceRepository == null)
            {
                _deviceRepository = GetRepository(x => x.GetDeviceRepository());
            }

            return _deviceRepository;
        }

        public INetworkGuestRepository GetNetworkGuestRepository()
        {
            if (_networkGuestRepository == null)
            {
                _networkGuestRepository = GetRepository(x => x.GetNetworkGuestRepository());
            }

            return _networkGuestRepository;
        }

        public INetworkRepository GetNetworkRepository()
        {
            if (_networkRepository == null)
            {
                _networkRepository = GetRepository(x => x.GetNetworkRepository());
            }

            return _networkRepository;
        }

        public IScriptRepository GetScriptRepository()
        {
            if (_scriptRepository == null)
            {
                _scriptRepository = GetRepository(x => x.GetScriptRepository());
            }

            return _scriptRepository;
        }

        public ISessionRepository GetSessionRepository()
        {
            if (_sessionRepository == null)
            {
                _sessionRepository = GetRepository(x => x.GetSessionRepository());
            }

            return _sessionRepository;
        }

        public ITaskRepository GetTaskRepository()
        {
            if (_taskRepository == null)
            {
                _taskRepository = GetRepository(x => x.GetTaskRepository());
            }

            return _taskRepository;
        }

        public IUserRepository GetUserRepository()
        {
            if (_userRepository == null)
            {
                _userRepository = GetRepository(x => x.GetUserRepository());
            }

            return _userRepository;
        }

        private T GetRepository<T>(Func<IRepositoryFactory, T> selector)
        {
            return _repositoryFactories
                    .Select(x => selector(x))
                    .FirstOrDefault(x => x != null);
        }
    }
}
