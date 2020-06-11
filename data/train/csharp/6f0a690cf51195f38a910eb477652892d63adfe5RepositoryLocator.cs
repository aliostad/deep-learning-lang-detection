using Scheduler.Data.Specification;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Scheduler.Data.Implementation
{
    public class RepositoryLocator
    {

        private readonly SchedulerDatabaseConnection _databaseConnection;

        internal RepositoryLocator(SchedulerDatabaseConnection dbConnection)
        {
            _databaseConnection = dbConnection;

            //RegisterRepository(new AppointmentRepository(_databaseConnection));
            //RegisterRepository(new ResourceRepository(_databaseConnection));
            //RegisterRepository(new UserRepository(_databaseConnection));
            RegisterRepository(new AccountRepository(_databaseConnection));
            //RegisterRepository(new ImageRepository(_databaseConnection));
            //RegisterRepository(new EnterpriseServicesRepository());
            //RegisterRepository(new AuditRepository(_databaseConnection));
            //RegisterRepository(new MammographyRepository(_databaseConnection));
            //RegisterRepository(new AccountSettingRepository(_databaseConnection));
        }

        //private IAppointmentRepository _appointmentRepository;
        private IAccountRepository _accountRepository;
        //private IResourceRepository _resourceRepository;
        //private IUserRepository _userRepository;
        //private IImageRepository _imageRepository;
        //private IAuditRepository _auditRepository;
        //private IEnterpriseServiceRepository _enterpriseServiceRepository;
        //private IMammographyRepository _mammographyRepository;
        //private IAccountSettingRepository _accountSettingRepository;

        internal void RegisterRepository(IRepository repository)
        {
            //if (repository is IAppointmentRepository)
            //    _appointmentRepository = repository as IAppointmentRepository;
            //else 
            if (repository is IAccountRepository)
                _accountRepository = repository as IAccountRepository;
            //else if (repository is IResourceRepository)
            //    _resourceRepository = repository as IResourceRepository;
            //else if (repository is IUserRepository)
            //    _userRepository = repository as IUserRepository;
            //else if (repository is IImageRepository)
            //    _imageRepository = repository as IImageRepository;
            //else if (repository is IEnterpriseServiceRepository)
            //    _enterpriseServiceRepository = repository as IEnterpriseServiceRepository;
            //else if (repository is IAuditRepository)
            //    _auditRepository = repository as IAuditRepository;
            //else if (repository is IMammographyRepository)
            //    _mammographyRepository = repository as IMammographyRepository;
            //else if (repository is IAccountSettingRepository)
            //    _accountSettingRepository = repository as IAccountSettingRepository;
        }

        internal void UnRegisterRepository(IRepository repository)
        {
            //if (repository is IAppointmentRepository)
            //    _appointmentRepository = null;
            //else 
            if (repository is IAccountRepository)
                _accountRepository = null;
            //else if (repository is IResourceRepository)
            //    _resourceRepository = null;
            //else if (repository is IUserRepository)
            //    _userRepository = null;
            //else if (repository is IImageRepository)
            //    _imageRepository = null;
            //else if (repository is IEnterpriseServiceRepository)
            //    _enterpriseServiceRepository = null;
            //else if (repository is IAuditRepository)
            //    _auditRepository = null;
            //else if (repository is IMammographyRepository)
            //    _mammographyRepository = null;
            //else if (repository is IAccountSettingRepository)
            //    _accountSettingRepository = null;
        }

        //public IAppointmentRepository AppointmentRepository
        //{
        //    get { return _appointmentRepository; }
        //}

        //public IUserRepository UserRepository
        //{
        //    get { return _userRepository; }
        //}

        //public IMammographyRepository MammographyRepository
        //{
        //    get { return _mammographyRepository; }
        //}

        public IAccountRepository AccountRepository
        {
            get { return _accountRepository; }
        }

        //public IResourceRepository ResourceRepository
        //{
        //    get { return _resourceRepository; }
        //}

        //public IImageRepository ImageRepository
        //{
        //    get { return _imageRepository; }
        //}

        //public IEnterpriseServiceRepository EnterpriseServiceRepository
        //{
        //    get { return _enterpriseServiceRepository; }
        //}

        //public IAuditRepository AuditRepository
        //{
        //    get { return _auditRepository; }
        //}

        //public IAccountSettingRepository AccountSettingRepository
        //{
        //    get { return _accountSettingRepository; }
        //}
    }
}
