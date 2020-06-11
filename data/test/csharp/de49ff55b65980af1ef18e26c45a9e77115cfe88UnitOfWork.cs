using KiddyShop.Account;
using KiddyShop.Account.Repositories;
using KiddyShop.Application;
using KiddyShop.Community;
using KiddyShop.Application.Repositories;
using KiddyShop.Data.EntityFramework;
using KiddyShop.Domain;
using KiddyShop.Messaging;
using KiddyShop.Messaging.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using KiddyShop.Community.Repositories;

namespace KiddyShop.Data.Repositories
{
    public class UnitOfWork : IUnitOfWork
    {
        private IDbFactory _dbFactory;
        private IKSDataContext _dbContext;

        private IAppClaimRepository _appClaimRepository;
        private IAppFunctionRepository _appFunctionRepository;
        private IRoleGroupRepository _roleGroupRepository;

        private ICountryRepository _countryRepository;
        private ITimezoneRepository _timezoneRepository;

        private IUserAttachmentRepository _userAttachmentRepository;

        private IProfileRepository _profileRepository;
        private IAccountRepository _accountRepository;
        private ITeacherRepository _teacherRepository;

        private IPostCategoryRepository _postCategoryRepository;

        private IMessagingDataMappingRepository _messagingDataMappingRepository;
        private IMessagingMessageRepository _messagingMessageRepository;
        private IMessagingTemplateContentRepository _messagingTemplateContentRepository;
        private IMessagingTemplateRepository _messagingTemplateRepository;
        private IMessagingTypeRepository _messagingTypeRepository;

        public UnitOfWork()
        {
            this._dbFactory = new DbFactory();
            _dbContext = _dbFactory.Init();
        }

        public UnitOfWork(IKSDataContext context)
        {
            _dbContext = context;
        }

        public int SaveChanges()
        {
            return _dbContext.SaveChanges();
        }

        public IAppClaimRepository AppClaimRepository => _appClaimRepository ?? (_appClaimRepository = new AppClaimRepository(_dbContext));
        public IAppFunctionRepository AppFunctionRepository => _appFunctionRepository ?? (_appFunctionRepository = new AppFunctionRepository(_dbContext));
        public IRoleGroupRepository RoleGroupRepository => _roleGroupRepository ?? (_roleGroupRepository = new RoleGroupRepository(_dbContext));

        public ICountryRepository CountryRepository => _countryRepository ?? (_countryRepository = new CountryRepository(_dbContext));
        public ITimezoneRepository TimezoneRepository => _timezoneRepository ?? (_timezoneRepository = new TimezoneRepository(_dbContext));

        public IUserAttachmentRepository UserAttachmentRepository => _userAttachmentRepository ?? (_userAttachmentRepository = new UserAttachmentRepository(_dbContext));

        public IProfileRepository ProfileRepository => _profileRepository ?? (_profileRepository = new ProfileRepository(_dbContext));
        public IAccountRepository AccountRepository => _accountRepository ?? (_accountRepository = new AccountRepository(_dbContext));
        public ITeacherRepository TeacherRepository => _teacherRepository ?? (_teacherRepository = new TeacherRepository(_dbContext));
        public IPostCategoryRepository PostCategoryRepository => _postCategoryRepository ?? (_postCategoryRepository = new PostCategoryRepository(_dbContext));

        public IMessagingDataMappingRepository MessagingDataMappingRepository => _messagingDataMappingRepository ?? (_messagingDataMappingRepository = new MessagingDataMappingRepository(_dbContext));
        public IMessagingMessageRepository MessagingMessageRepository => _messagingMessageRepository ?? (_messagingMessageRepository = new MessagingMessageRepository(_dbContext));
        public IMessagingTemplateContentRepository MessagingTemplateContentRepository => _messagingTemplateContentRepository ?? (_messagingTemplateContentRepository = new MessagingTemplateContentRepository(_dbContext));
        public IMessagingTemplateRepository MessagingTemplateRepository => _messagingTemplateRepository ?? (_messagingTemplateRepository = new MessagingTemplateRepository(_dbContext));
        public IMessagingTypeRepository MessagingTypeRepository => _messagingTypeRepository ?? (_messagingTypeRepository = new MessagingTypeRepository(_dbContext));


        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        private void Dispose(bool disposing)
        {
            if (!disposing) return;
            if (_dbContext == null) return;
            _dbContext.Dispose();
            _dbContext = null;

            _profileRepository = null;
            _accountRepository = null;
            _teacherRepository = null;

            //_classGroupRepository = null;
            //_classRoomRepository = null;
            //_courseRepository = null;
            //_divisionRepository = null;
            //_organizationRepository = null;
            //_semesterRepository = null;
            //_subjectGroupRepository = null;
            //_subjectRepository = null;
            //_buildingRepository = null;
            //_roomRepository = null;
            //_teacherDivisionRepository = null;

            //_classTimetableRepository = null;
            //_TimetableRepository = null;

            //_courseSectionRepository = null;
            //_schedulingTableRepository = null;

            //_courseSubjectRepository = null;
            //_trainingProgramRepository = null;

            _messagingDataMappingRepository = null;
            _messagingMessageRepository = null;
            _messagingTemplateContentRepository = null;
            _messagingTemplateRepository = null;
            _messagingTypeRepository = null;
        }

    }
}
