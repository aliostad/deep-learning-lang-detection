using System;
using StoneCastle.Data.EntityFramework;
using StoneCastle.Domain;
using StoneCastle.Application;
using StoneCastle.Application.Repositories;
using StoneCastle.Account;
using StoneCastle.Account.Repositories;
using StoneCastle.Organization;
using StoneCastle.Schedule;
using StoneCastle.TrainingProgram;
using StoneCastle.Schedule.Repositories;
using StoneCastle.TrainingProgram.Repositories;
using StoneCastle.Organization.Repositories;
using StoneCastle.Messaging;
using StoneCastle.Messaging.Repositories;

namespace StoneCastle.Data.Repositories
{
    public class UnitOfWork : IUnitOfWork
    {
        private IDbFactory _dbFactory;
        private ISCDataContext _dbContext;

        private ICountryRepository _countryRepository;
        private ITimezoneRepository _timezoneRepository;

        private IProfileRepository _profileRepository;
        private IAccountRepository _accountRepository;
        private ITeacherRepository _teacherRepository;

        private IClassGroupRepository _classGroupRepository;
        private IClassRoomRepository _classRoomRepository;
        private IClassCourseRepository _courseRepository;
        private IDivisionRepository _divisionRepository;
        private IOrganizationRepository _organizationRepository;
        private ISemesterRepository _semesterRepository;
        private ISubjectGroupRepository _subjectGroupRepository;
        private ISubjectRepository _subjectRepository;
        private IBuildingRepository _buildingRepository;
        private IRoomRepository _roomRepository;
        private ITeacherDivisionRepository _teacherDivisionRepository;

        private IClassTimetableRepository _classTimetableRepository;
        private ITimetableRepository _TimetableRepository;

        private ICourseSectionRepository _courseSectionRepository;
        private ISchedulingTableRepository _schedulingTableRepository;

        private ICourseRepository _courseSubjectRepository;
        private ITrainingProgramRepository _trainingProgramRepository;

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

        public UnitOfWork(ISCDataContext context)
        {
            _dbContext = context;
        }

        public int SaveChanges()
        {
            return _dbContext.SaveChanges();
        }

        public ICountryRepository CountryRepository => _countryRepository ?? (_countryRepository = new CountryRepository(_dbContext));
        public ITimezoneRepository TimezoneRepository => _timezoneRepository ?? (_timezoneRepository = new TimezoneRepository(_dbContext));

        public IProfileRepository ProfileRepository => _profileRepository ?? (_profileRepository = new ProfileRepository(_dbContext));
        public IAccountRepository AccountRepository => _accountRepository ?? (_accountRepository = new AccountRepository(_dbContext));
        public ITeacherRepository TeacherRepository => _teacherRepository ?? (_teacherRepository = new TeacherRepository(_dbContext));

        public IClassGroupRepository ClassGroupRepository => _classGroupRepository ?? (_classGroupRepository = new ClassGroupRepository(_dbContext));
        public IClassRoomRepository ClassRoomRepository => _classRoomRepository ?? (_classRoomRepository = new ClassRoomRepository(_dbContext));
        public IClassCourseRepository ClassCourseRepository => _courseRepository ?? (_courseRepository = new ClassCourseRepository(_dbContext));
        public IDivisionRepository DivisionRepository => _divisionRepository ?? (_divisionRepository = new DivisionRepository(_dbContext));
        public IOrganizationRepository OrganizationRepository => _organizationRepository ?? (_organizationRepository = new OrganizationRepository(_dbContext));
        public ISemesterRepository SemesterRepository => _semesterRepository ?? (_semesterRepository = new SemesterRepository(_dbContext));
        public ISubjectGroupRepository SubjectGroupRepository => _subjectGroupRepository ?? (_subjectGroupRepository = new SubjectGroupRepository(_dbContext));
        public ISubjectRepository SubjectRepository => _subjectRepository ?? (_subjectRepository = new SubjectRepository(_dbContext));
        public IBuildingRepository BuildingRepository => _buildingRepository ?? (_buildingRepository = new BuildingRepository(_dbContext));
        public IRoomRepository RoomRepository => _roomRepository ?? (_roomRepository = new RoomRepository(_dbContext));
        public ITeacherDivisionRepository TeacherDivisionRepository => _teacherDivisionRepository ?? (_teacherDivisionRepository = new TeacherDivisionRepository(_dbContext));

        public IClassTimetableRepository ClassTimetableRepository => _classTimetableRepository ?? (_classTimetableRepository = new ClassTimetableRepository(_dbContext));
        public ITimetableRepository TimetableRepository => _TimetableRepository ?? (_TimetableRepository = new TimetableRepository(_dbContext));

        public ICourseSectionRepository CourseSectionRepository => _courseSectionRepository ?? (_courseSectionRepository = new CourseSectionRepository(_dbContext));
        public ISchedulingTableRepository SchedulingTableRepository => _schedulingTableRepository ?? (_schedulingTableRepository = new SchedulingTableRepository(_dbContext));

        public ICourseRepository CourseRepository => _courseSubjectRepository ?? (_courseSubjectRepository = new CourseRepository(_dbContext));
        public ITrainingProgramRepository TrainingProgramRepository => _trainingProgramRepository ?? (_trainingProgramRepository = new TrainingProgramRepository(_dbContext));


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

            _classGroupRepository = null;
            _classRoomRepository = null;
            _courseRepository = null;
            _divisionRepository = null;
            _organizationRepository = null;
            _semesterRepository = null;
            _subjectGroupRepository = null;
            _subjectRepository = null;
            _buildingRepository = null;
            _roomRepository = null;
            _teacherDivisionRepository = null;

            _classTimetableRepository = null;
            _TimetableRepository = null;

            _courseSectionRepository = null;
            _schedulingTableRepository = null;

            _courseSubjectRepository = null;
            _trainingProgramRepository = null;

            _messagingDataMappingRepository = null;
            _messagingMessageRepository = null;
            _messagingTemplateContentRepository = null;
            _messagingTemplateRepository = null;
            _messagingTypeRepository = null;
        }
    }
}
