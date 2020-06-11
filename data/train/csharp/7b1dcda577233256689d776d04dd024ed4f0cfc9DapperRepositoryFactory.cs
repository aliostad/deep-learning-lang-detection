using System;
using System.Data;

namespace Roomie.Web.Persistence.Repositories.DapperRepositories
{
    public class DapperRepositoryFactory : IRepositoryFactory
    {
        private IDbConnection _connection;
        private Lazy<IRepositoryFactory> _parentFactory;

        private IComputerRepository _computerRepository;
        private IDeviceRepository _deviceRepository;
        private INetworkGuestRepository _networkGuestRepository;
        private INetworkRepository _networkRepositoryWithGuests;
        private INetworkRepository _networkRepositoryWithoutGuests;
        private ISessionRepository _sessionRepository;
        private IScriptRepository _scriptRepository;
        private ITaskRepository _taskRepository;
        private IUserRepository _userRepository;

        public DapperRepositoryFactory(IDbConnection connection, Lazy<IRepositoryFactory> parentFactory)
        {
            _connection = connection;
            _parentFactory = parentFactory;
        }

        public IComputerRepository GetComputerRepository()
        {
            if (_computerRepository == null)
            {
                var scriptRepository = GetRepository(x => x.GetScriptRepository());
                var userRepository = GetRepository(x => x.GetUserRepository());
                _computerRepository = new ComputerRepository(_connection, scriptRepository, userRepository);
            }

            return _computerRepository;
        }

        public IDeviceRepository GetDeviceRepository()
        {
            if (_deviceRepository == null)
            {
                var networkRepository = GetRepository(x => x.GetNetworkRepository());
                var scriptRepository = GetRepository(x => x.GetScriptRepository());
                var taskRepository = GetRepository(x => x.GetTaskRepository());
                _deviceRepository = new DeviceRepository(_connection, networkRepository, scriptRepository, taskRepository);
            }

            return _deviceRepository;
        }

        public INetworkGuestRepository GetNetworkGuestRepository()
        {
            if (_networkGuestRepository == null)
            {
                var networkRepository = GetNetworkRepositoryWithoutGuests();
                var userRepository = GetRepository(x => x.GetUserRepository());

                _networkGuestRepository = new NetworkGuestRepository(_connection, networkRepository, userRepository);
            }

            return _networkGuestRepository;
        }

        public INetworkRepository GetNetworkRepository()
        {
            if (_networkRepositoryWithGuests == null)
            {
                var networkGuestRepository = GetRepository(x => x.GetNetworkGuestRepository());
                var networkRepository = GetNetworkRepositoryWithoutGuests();

                _networkRepositoryWithGuests = new GuestEnabledNetworkRepository(networkRepository, networkGuestRepository);
            }

            return _networkRepositoryWithGuests;
        }

        private INetworkRepository GetNetworkRepositoryWithoutGuests()
        {
            if (_networkRepositoryWithoutGuests == null)
            {
                var computerRepository = GetRepository(x => x.GetComputerRepository());
                var userRepository = GetRepository(x => x.GetUserRepository());

                _networkRepositoryWithoutGuests = new NetworkRepository(_connection, computerRepository, userRepository);
            }

            return _networkRepositoryWithoutGuests;
        }

        public IScriptRepository GetScriptRepository()
        {
            if (_scriptRepository == null)
            {
                _scriptRepository = new ScriptRepository(_connection);
            }

            return _scriptRepository;
        }

        public ISessionRepository GetSessionRepository()
        {
            if (_sessionRepository == null)
            {
                var computerRepository = GetRepository(x => x.GetComputerRepository());
                var userRepository = GetRepository(x => x.GetUserRepository());

                _sessionRepository = new SessionRepository(
                    new UserSessionRepository(_connection, userRepository),
                    new WebHookSessionRepository(_connection, computerRepository)
                );
            }

            return _sessionRepository;
        }

        public ITaskRepository GetTaskRepository()
        {
            if (_taskRepository == null)
            {
                var computerRepository = GetRepository(x => x.GetComputerRepository());
                var scriptRepository = GetRepository(x => x.GetScriptRepository());
                var userRepository = GetRepository(x => x.GetUserRepository());

                _taskRepository = new TaskRepository(_connection, computerRepository, scriptRepository, userRepository);
            }

            return _taskRepository;
        }

        public IUserRepository GetUserRepository()
        {
            if (_userRepository == null)
            {
                _userRepository = new UserRepository(_connection);
            }

            return _userRepository;
        }

        private T GetRepository<T>(Func<IRepositoryFactory, T> selector)
        {
            var factory = _parentFactory?.Value ?? this;

            return selector(factory);
        }
    }
}
