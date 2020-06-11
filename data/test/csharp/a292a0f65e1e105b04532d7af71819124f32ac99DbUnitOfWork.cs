using CollegeBuffer.BLL.Repositories;
using CollegeBuffer.DAL.Context;

namespace CollegeBuffer.BLL
{
    public class DbUnitOfWork : BaseUnitOfWork
    {
        public static DbUnitOfWork NewInstance()
        {
            return new DbUnitOfWork();
        }

        #region Fields

        private UsersRepository _usersRepository;
        private GroupsRepository _groupsRepository;
        private SessionsRepository _sessionsRepository;
        private GroupRequestsRepository _groupRequestsRepository;
        private SubjectsRepository _subjectsRepository;
        private CommentsRepository _commentsRepository;
        private AnnouncementsRepository _announcementsRepository;
        private AnnouncementNotificationsRepository _announcementNotificationsRepository;
        private EventNotificationsRepository _eventNotificationsRepository;
        private CalendarsRepository _calendarsRepository;
        private CalendarEntriesRespository _calendarEntriesRespository;
        private EventsRepository _eventsRepository;

        #endregion

        #region properties

        public UsersRepository UsersRepository
        {
            get
            {
                return _usersRepository ?? (_usersRepository = new UsersRepository(DbContext));
            }
        }

        public GroupsRepository GroupsRepository
        {
            get
            {
                return _groupsRepository ?? (_groupsRepository = new GroupsRepository(DbContext));
            }
        }

        public SessionsRepository SessionsRepository
        {
            get
            {
                return _sessionsRepository ?? (_sessionsRepository = new SessionsRepository(DbContext));
            }
        }

        public GroupRequestsRepository GroupRequestsRepository
        {
            get
            {
                return _groupRequestsRepository ?? (_groupRequestsRepository = new GroupRequestsRepository(DbContext));
            }
        }

        public SubjectsRepository SubjectsRepository
        {
            get
            {
                return _subjectsRepository ?? (_subjectsRepository = new SubjectsRepository(DbContext));
            }
        }

        public CommentsRepository CommentsRepository
        {
            get
            {
                return _commentsRepository ?? (_commentsRepository = new CommentsRepository(DbContext));
            }
        }

        public AnnouncementsRepository AnnouncementsRepository
        {
            get
            {
                return _announcementsRepository ?? (_announcementsRepository = new AnnouncementsRepository(DbContext));
            }
        }

        public AnnouncementNotificationsRepository AnnouncementNotificationsRepository
        {
            get
            {
                return _announcementNotificationsRepository ??
                       (_announcementNotificationsRepository = new AnnouncementNotificationsRepository(DbContext));
            }
        }

        public EventNotificationsRepository EventNotificationsRepository
        {
            get
            {
                return _eventNotificationsRepository ??
                       (_eventNotificationsRepository = new EventNotificationsRepository(DbContext));
            }
        }

        public CalendarsRepository CalendarsRepository
        {
            get
            {
                return _calendarsRepository ?? (_calendarsRepository = new CalendarsRepository(DbContext));
            }

        }

        public CalendarEntriesRespository CalendarEntriesRespository
        {
            get
            {
                return _calendarEntriesRespository ??
                       (_calendarEntriesRespository = new CalendarEntriesRespository(DbContext));
            }
        }

        public EventsRepository EventsRepository
        {
            get
            {
                return _eventsRepository ?? (_eventsRepository = new EventsRepository(DbContext));
            }
        }

        #endregion
    }
}