
namespace TaskManager.Models.Repository
{
    public partial class UnitOfWork
    {

        private GenericRepository<Project> _projectsRepository;
        public GenericRepository<Project> ProjectsRepository
        {
			get { return _projectsRepository ?? (_projectsRepository = new GenericRepository<Project>(_context)); }
        }

        private GenericRepository<Module> _modulesRepository;
        public GenericRepository<Module> ModulesRepository
        {
			get { return _modulesRepository ?? (_modulesRepository = new GenericRepository<Module>(_context)); }
        }

        private GenericRepository<TaskCategory> _taskcategoriesRepository;
        public GenericRepository<TaskCategory> TaskCategoriesRepository
        {
			get { return _taskcategoriesRepository ?? (_taskcategoriesRepository = new GenericRepository<TaskCategory>(_context)); }
        }

        private GenericRepository<TaskReportDetail> _taskreportdetailsRepository;
        public GenericRepository<TaskReportDetail> TaskReportDetailsRepository
        {
			get { return _taskreportdetailsRepository ?? (_taskreportdetailsRepository = new GenericRepository<TaskReportDetail>(_context)); }
        }

        private GenericRepository<TaskFormDetail> _taskformdetailsRepository;
        public GenericRepository<TaskFormDetail> TaskFormDetailsRepository
        {
			get { return _taskformdetailsRepository ?? (_taskformdetailsRepository = new GenericRepository<TaskFormDetail>(_context)); }
        }

        private GenericRepository<TaskNote> _tasknotesRepository;
        public GenericRepository<TaskNote> TaskNotesRepository
        {
			get { return _tasknotesRepository ?? (_tasknotesRepository = new GenericRepository<TaskNote>(_context)); }
        }

        private GenericRepository<Task> _tasksRepository;
        public GenericRepository<Task> TasksRepository
        {
			get { return _tasksRepository ?? (_tasksRepository = new GenericRepository<Task>(_context)); }
        }

        private GenericRepository<Comment> _commentsRepository;
        public GenericRepository<Comment> CommentsRepository
        {
			get { return _commentsRepository ?? (_commentsRepository = new GenericRepository<Comment>(_context)); }
        }
 
    }
}

