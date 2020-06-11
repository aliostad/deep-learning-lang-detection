using System;
using FormBuilder.Business.Entities;
using FormBuilder.Data.Contracts;

namespace FormBuilder.Data
{
    public class ApplicationUnit: IApplicationUnit
    {
        private FormBuilderContext _context;

        private IGenericRepository<User> _userRepository;
        private IGenericRepository<Role> _roleRepository;
        private IGenericRepository<Group> _groupRepository;
        private IGenericRepository<Event> _eventRepository;
        private IGenericRepository<JoinGroupRequest> _joinGroupRequestRepository;
        private IGenericRepository<Sponsor> _sponsorRepository;
        private IGenericRepository<GroupPhoto> _groupPhotoRepository;
        private IGenericRepository<PersonalMessage> _personalMessageRepository; 

        public ApplicationUnit(IGenericRepository<User> userRepository, 
                               IGenericRepository<Role> roleRepository,
                               IGenericRepository<Group> groupRepository,
                               IGenericRepository<Event> eventRepository,
                               IGenericRepository<Sponsor> sponsorRepository,
                               IGenericRepository<JoinGroupRequest> joinGroupRequestRepository,
                               IGenericRepository<GroupPhoto> groupPhotoRepository,
                               IGenericRepository<PersonalMessage> personalMessageRepository,
                               FormBuilderContext formBuilderContext)
        {
            _userRepository = userRepository;
            _roleRepository = roleRepository;
            _groupRepository = groupRepository;
            _eventRepository = eventRepository;
            _sponsorRepository = sponsorRepository;
            _joinGroupRequestRepository = joinGroupRequestRepository;
            _groupPhotoRepository = groupPhotoRepository;
            _personalMessageRepository = personalMessageRepository;
            _context = formBuilderContext;
        }

        public IGenericRepository<PersonalMessage> PersonalMessageRepository
        {
            get { return this._personalMessageRepository; }
        }

        public IGenericRepository<GroupPhoto> GroupPhotoRepository
        {
            get { return this._groupPhotoRepository; }
        }

        public IGenericRepository<Sponsor> SponsoRepository
        {
            get { return this._sponsorRepository; }
        }

        public IGenericRepository<JoinGroupRequest> JoinGroupRequestRepository
        {
            get { return this._joinGroupRequestRepository; }
        }

        public IGenericRepository<Event> EventRepository
        {
            get { return this._eventRepository; }
        }

        public IGenericRepository<Group> GroupRepository
        {
            get { return this._groupRepository; }
        }

        public IGenericRepository<User> UserRepository
        {
            get { return this._userRepository; }
        }

        public IGenericRepository<Role> RoleRepository
        {
            get { return this._roleRepository; }
        }

        public void SaveChanges()
        {
            _context.SaveChanges();
        }

        private bool disposed = false;

        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposed)
            {
                if (disposing)
                {
                    _context.Dispose();
                }
            }
            this.disposed = true;
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
    }
}
