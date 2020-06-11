using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using PMTool.Models;

namespace PMTool.Repository
{
    public class UnitOfWork : IDisposable
    {

        private PMToolContext context;
        public UnitOfWork()
        {
            context = new PMToolContext();
        }
        
        public UnitOfWork(PMToolContext _context)
        {
            this.context = _context;
        }


        private UserProfileRepository _userProfileRepository;

        public UserProfileRepository UserProfileRepository
        {
            get
            {

                if (this._userProfileRepository == null)
                {
                    //this._userProfileRepository = new UserProfileRepository(context);
                }
                return _userProfileRepository;
            }
        }

        private MembershipRepository _membershipRepository;

        public MembershipRepository MembershipRepository
        {
            get
            {

                if (this._membershipRepository == null)
                {
                    //this._userProfileRepository = new UserProfileRepository(context);
                }
                return _membershipRepository;
            }
        }

        private TaskMessageRepository _taskMessageRepository;

        public TaskMessageRepository TaskMessageRepository
        {
            get
            {

                if (this._taskMessageRepository == null)
                {
                    this._taskMessageRepository = new TaskMessageRepository(context);
                }
                return _taskMessageRepository;
            }
        }

        private LabelRepository _labelRepository;

        public LabelRepository LabelRepository
        { 
            get
            {

                if (this._labelRepository == null)
                {
                    this._labelRepository = new LabelRepository(context);
                }
                return _labelRepository;
            }
        }

        private TaskRepository _taskRepository;

        public TaskRepository TaskRepository
        {
            get
            {

                if (this._taskRepository == null)
                {
                    this._taskRepository = new TaskRepository(context);
                }
                return _taskRepository;
            }
        }

        private ProjectRepository _projectRepository;

        public ProjectRepository ProjectRepository
        {
            get
            {

                if (this._projectRepository == null)
                {
                    this._projectRepository = new ProjectRepository(context);
                }
                return _projectRepository;
            }
        }

        private PriorityRepository _priorityRepository;

        public PriorityRepository PriorityRepository
        {
            get
            {

                if (this._priorityRepository == null)
                {
                    this._priorityRepository = new PriorityRepository(context);
                }
                return _priorityRepository;
            }
        }

        private UserRepository _userRepository;

        public UserRepository UserRepository
        {
            get
            {

                if (this._userRepository == null)
                {
                    this._userRepository = new UserRepository(context);
                }
                return _userRepository;
            }
        }

        private NotificationRepository _notificationRepository;

        public NotificationRepository NotificationRepository
        {
            get
            {

                if (this._notificationRepository == null)
                {
                    this._notificationRepository = new NotificationRepository(context);
                }
                return _notificationRepository;
            }
        }

        private ProjectStatusRepository _ProjectStatusRepository;

        public ProjectStatusRepository ProjectStatusRepository
        {
            get
            {

                if (this._ProjectStatusRepository == null)
                {
                    this._ProjectStatusRepository = new ProjectStatusRepository(context);
                }
                return _ProjectStatusRepository;
            }
        }

        private SprintRepository _sprintRepository;

        public SprintRepository SprintRepository
        {
            get
            {

                if (this._sprintRepository == null)
                {
                    this._sprintRepository = new SprintRepository(context);
                }
                return _sprintRepository;
            }
        }

        private TaskActivityLogRepository _taskActivityLogRepository;

        public TaskActivityLogRepository TaskActivityLogRepository
        {
            get
            {

                if (this._taskActivityLogRepository == null)
                {
                    this._taskActivityLogRepository = new TaskActivityLogRepository(context);
                }
                return _taskActivityLogRepository;
            }
        }

        private ProjectStatusRuleRepository _projectStatusRuleRepository;

        public ProjectStatusRuleRepository ProjectStatusRuleRepository
        {
            get
            {

                if (this._projectStatusRuleRepository == null)
                {
                    this._projectStatusRuleRepository = new ProjectStatusRuleRepository(context);
                }
                return _projectStatusRuleRepository;
            }
        }


        private TimeLogRepository _timeLogRepository;
        public TimeLogRepository TimeLogRepository
        {
            get
            {
                if (this._timeLogRepository == null)
                {
                    this._timeLogRepository = new TimeLogRepository(context);
                }
                return _timeLogRepository;
            }
        }


        private CommentRepository _commentRepository;
        public CommentRepository CommentRepository
        {
            get
            {
                if (this._commentRepository == null)
                {
                    this._commentRepository = new CommentRepository(context);
                }
                return _commentRepository;
            }
        }

        private EmailProcessor _emailProcessor;
        public EmailProcessor EmailProcessor
        {
            get
            {

                if (this._emailProcessor == null)
                {
                    this._emailProcessor = new EmailProcessor();
                }
                return _emailProcessor;
            }
        }


        private EmailSchedulerRepository _emailSchedulerRepository;
        public EmailSchedulerRepository EmailSchedulerRepository
        {
            get
            {
                if (this._emailSchedulerRepository == null)
                {
                    this._emailSchedulerRepository = new EmailSchedulerRepository(context);
                }
                return _emailSchedulerRepository;
            }

        }

        private EmailSentStatusRepository _emailSentStatusRepository;
        public EmailSentStatusRepository EmailSentStatusRepository
        {
            get
            {
                if (this._emailSentStatusRepository == null)
                {
                    this._emailSentStatusRepository = new EmailSentStatusRepository(context);
                }
                return _emailSentStatusRepository;
            }

        }


        



        public void Save()
        {
            context.SaveChanges();
        }

        private bool disposed = false;

        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposed)
            {
                if (disposing)
                {
                    context.Dispose();
                }
            }
            this.disposed = true;
        }

        public void Dispose()
        {
            context.Dispose();
            GC.SuppressFinalize(this);
        }

    }
}
