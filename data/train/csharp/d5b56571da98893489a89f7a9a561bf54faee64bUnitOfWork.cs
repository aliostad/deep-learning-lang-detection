using DataService.Repository;
using Models;

namespace DataService.UnitOfWork
{
    public class UnitOfWork
    {
        private readonly object _db;

        private GenericRepository<Skill> _skillRepository;
        private GenericRepository<About> _aboutRepository;
        private GenericRepository<Resume> _resumeRepository;
        private GenericRepository<TimeStamp> _timeStampRepository;
        private GenericRepository<Project> _projectRepository;
        private GenericRepository<Reference> _referenceRepository;

        public UnitOfWork(object db)
        {
            _db = db;
        }

        public GenericRepository<Skill> SkillRepository => _skillRepository ?? (_skillRepository = new GenericRepository<Skill>(_db));

        public GenericRepository<About> AboutRepository => _aboutRepository ?? (_aboutRepository = new GenericRepository<About>(_db));

        public GenericRepository<Resume> ResumeRepository => _resumeRepository ?? (_resumeRepository = new GenericRepository<Resume>(_db));

        public GenericRepository<TimeStamp> TimeStampRepository => _timeStampRepository ?? (_timeStampRepository = new GenericRepository<TimeStamp>(_db));

        public GenericRepository<Project> ProjectRepository => _projectRepository ?? (_projectRepository = new GenericRepository<Project>(_db));

        public GenericRepository<Reference> ReferenceRepository => _referenceRepository ?? (_referenceRepository = new GenericRepository<Reference>(_db));
    }
}
