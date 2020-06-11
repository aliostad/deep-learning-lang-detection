using StoneCastle.Application;
using StoneCastle.Account;
using StoneCastle.Organization;
using StoneCastle.Schedule;
using StoneCastle.TrainingProgram;
using StoneCastle.Messaging;

namespace StoneCastle.Domain
{
    public interface IUnitOfWork
    {
        int SaveChanges();

        ICountryRepository CountryRepository { get; }
        ITimezoneRepository TimezoneRepository { get; }

        IProfileRepository ProfileRepository { get; }
        IAccountRepository AccountRepository  { get; }
        ITeacherRepository TeacherRepository { get; }

        IClassGroupRepository ClassGroupRepository { get; }
        IClassRoomRepository ClassRoomRepository { get; }
        IClassCourseRepository ClassCourseRepository { get; }
        IDivisionRepository DivisionRepository { get; }
        IOrganizationRepository OrganizationRepository { get; }
        ISemesterRepository SemesterRepository { get; }
        ISubjectGroupRepository SubjectGroupRepository { get; }
        ISubjectRepository SubjectRepository { get; }
        IBuildingRepository BuildingRepository { get; }
        IRoomRepository RoomRepository { get; }
        ITeacherDivisionRepository TeacherDivisionRepository { get; }

        IClassTimetableRepository ClassTimetableRepository { get; }
        ITimetableRepository TimetableRepository { get; }

        ICourseSectionRepository CourseSectionRepository { get; }
        ISchedulingTableRepository SchedulingTableRepository { get; }

        ICourseRepository CourseRepository { get; }
        ITrainingProgramRepository TrainingProgramRepository { get; }

        IMessagingDataMappingRepository MessagingDataMappingRepository { get; }
        IMessagingMessageRepository MessagingMessageRepository { get; }
        IMessagingTemplateContentRepository MessagingTemplateContentRepository { get; }
        IMessagingTemplateRepository MessagingTemplateRepository { get; }
        IMessagingTypeRepository MessagingTypeRepository { get; }
    }
}
