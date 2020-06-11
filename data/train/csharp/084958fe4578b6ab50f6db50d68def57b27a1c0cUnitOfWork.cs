using System;
using NordicaAssistans.Data.Repositories;

namespace NordicaAssistans.Data
{
    public interface IUnitOfWork
    {
        UserRepository UserRepository { get; }
        ClientRepository ClientRepository { get; }
        AssistantRepository AssistantRepository { get; }
        AssistanceRepository AssistanceRepository { get; }
        PaymentRepository PaymentRepository { get; }
        LogRepository ChangeLogRepository { get; }
        DivergenceRepository DivergenceRepository { get; }
        ResultRepository ResultRepository { get; }
        PlanRepository PlanRepository { get; }
        PaymentComparisonRepository PaymentComparisonRepository { get; }
        ImportFileRepository ImportFileRepository { get; }
        PermissionRepository PermissionRepository { get; }
        UserPermissionRepository UserPermissionRepository { get; }
        SettingRepository SettingRepository { get; }
        SettingValueRepository SettingValueRepository { get; }
        ImportLogRepository ImportLogRepository { get;  }
        LogRepository LogRepository { get; }
        AgeGroupRepository AgeGroupRepository { get; }
        RateRepository RateRepository { get; }

        int Save();
    }

    public class UnitOfWork : IUnitOfWork, IDisposable
    {
        private readonly NordicaAssistansContext _context;
        private UserRepository _userRepository;
        private ClientRepository _clientRepository;
        private AssistantRepository _assistantRepository;
        private AssistanceRepository _assistanceRepository;
        private PaymentRepository _paymentRepository;
        private LogRepository _changeLogRepository;
        private DivergenceRepository _divergenceRepository;
        private ResultRepository _resultRepository;
        private PlanRepository _planRepository;
        private PaymentComparisonRepository _paymentComparisonRepository;
        private ImportFileRepository _importFileRepository;
        private PermissionRepository _permissionRepository;
        private UserPermissionRepository _userPermissionRepository;
        private SettingRepository _settingRepository;
        private SettingValueRepository _settingValueRepository;
        private ImportLogRepository _importLogRepository;
        private LogRepository _logRepository;
        private AgeGroupRepository _ageGroupRepository;
        private RateRepository _rateRepository;

        public UnitOfWork()
        {
            _context = new NordicaAssistansContext();
        }

        public UnitOfWork(string connStr)
        {
            _context = new NordicaAssistansContext(connStr);
        }

        public bool IsConnectionCorrect()
        {
            return _context.IsConnectionCorrect();
        }

        public UserRepository UserRepository
        {
            get
            {
                return _userRepository ?? (_userRepository = new UserRepository(_context));
            }
        }

        public ClientRepository ClientRepository
        {
            get
            {
                return _clientRepository ?? (_clientRepository = new ClientRepository(_context));
            }
        }

        public AssistantRepository AssistantRepository
        {
            get
            {
                return _assistantRepository ?? (_assistantRepository = new AssistantRepository(_context));
            }
        }

        public AssistanceRepository AssistanceRepository
        {
            get
            {
                return _assistanceRepository ?? (_assistanceRepository = new AssistanceRepository(_context));
            }
        }

        public PaymentRepository PaymentRepository
        {
            get
            {
                return _paymentRepository ?? (_paymentRepository = new PaymentRepository(_context));
            }
        }

        public LogRepository ChangeLogRepository
        {
            get
            {
                return _changeLogRepository ?? (_changeLogRepository = new LogRepository(_context));
            }
        }

        public DivergenceRepository DivergenceRepository
        {
            get
            {
                return _divergenceRepository ?? (_divergenceRepository = new DivergenceRepository(_context));
            }
        }

        public ResultRepository ResultRepository
        {
            get
            {
                return _resultRepository ?? (_resultRepository = new ResultRepository(_context));
            }
        }

        public PlanRepository PlanRepository
        {
            get
            {
                return _planRepository ?? (_planRepository = new PlanRepository(_context));
            }
        }

        public PaymentComparisonRepository PaymentComparisonRepository
        {
            get
            {
                return _paymentComparisonRepository ?? (_paymentComparisonRepository = new PaymentComparisonRepository(_context));
            }
        }

        public ImportFileRepository ImportFileRepository
        {
            get
            {
                return _importFileRepository ?? (_importFileRepository = new ImportFileRepository(_context));
            }
        }

        public PermissionRepository PermissionRepository
        {
            get
            {
                return _permissionRepository ?? (_permissionRepository = new PermissionRepository(_context));
            }
        }

        public UserPermissionRepository UserPermissionRepository
        {
            get
            {
                return _userPermissionRepository ?? (_userPermissionRepository = new UserPermissionRepository(_context));
            }
        }

        public SettingRepository SettingRepository
        {
            get
            {
                return _settingRepository ?? (_settingRepository = new SettingRepository(_context));
            }
        }

        public SettingValueRepository SettingValueRepository 
        {
            get
            {
                return _settingValueRepository ?? (_settingValueRepository = new SettingValueRepository(_context));
            }
        }

        public ImportLogRepository ImportLogRepository
        {
            get
            {
                return _importLogRepository ?? (_importLogRepository = new ImportLogRepository(_context));
            }
        }

        public LogRepository LogRepository
        {
            get
            {
                return _logRepository ?? (_logRepository = new LogRepository(_context));
            }
        }

        public AgeGroupRepository AgeGroupRepository
        {
            get
            {
                return _ageGroupRepository ?? (_ageGroupRepository = new AgeGroupRepository(_context));
            }
        }

        public RateRepository RateRepository
        {
            get
            {
                return _rateRepository ?? (_rateRepository = new RateRepository(_context));
            }
        }

        public int Save()
        {
            return _context.SaveChanges();
        }

        private bool _disposed;

        protected virtual void Dispose(bool disposing)
        {
            if (!_disposed)
            {
                if (disposing)
                {
                    _context.Dispose();
                }
            }

            _disposed = true;
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
    }
}