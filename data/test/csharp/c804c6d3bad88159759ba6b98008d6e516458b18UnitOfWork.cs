using DataService.Repository;

namespace DataService.UnitOfWork
{
    public class UnitOfWork
    {
        private readonly object _db;
        private GenericRepository<Prod> _activitieRepository;
        private GenericRepository<Actor> _actorRepository;
        private GenericRepository<R5> _agreementRepository;
        private GenericRepository<R1> _officeRepository;
        private GenericRepository<Ord> _orderRepository;
        private GenericRepository<R9> _projectRepository;
        private GenericRepository<R8> _serviceRepository;
        private GenericRepository<Agr> _timeStampsRepository;
        private GenericRepository<Txt> _typeOfWorkText;
        private GenericRepository<Unit> _unitRepository;
        private GenericRepository<Hol> _holRepository;
    


        public UnitOfWork(object db)
        {
            _db = db;
        }

        public GenericRepository<Agr> TimeStampsRepository
        {
            get { return _timeStampsRepository ?? (_timeStampsRepository = new GenericRepository<Agr>(_db)); }
        }

        public GenericRepository<Hol> RedDayRepository
        {
            get { return _holRepository ?? (_holRepository = new GenericRepository<Hol>(_db)); }
        }

        public GenericRepository<R1> OfficeRepository
        {
            get { return _officeRepository ?? (_officeRepository = new GenericRepository<R1>(_db)); }
        }

        public GenericRepository<Actor> ActorRepository
        {
            get { return _actorRepository ?? (_actorRepository = new GenericRepository<Actor>(_db)); }
        }

        public GenericRepository<Ord> OrderRepository
        {
            get { return _orderRepository ?? (_orderRepository = new GenericRepository<Ord>(_db)); }
        }

        public GenericRepository<Prod> ActivityRepository
        {
            get { return _activitieRepository ?? (_activitieRepository = new GenericRepository<Prod>(_db)); }
        }

        public GenericRepository<R5> AgreementRepository
        {
            get { return _agreementRepository ?? (_agreementRepository = new GenericRepository<R5>(_db)); }
        }

        public GenericRepository<R8> ServiceRepository
        {
            get { return _serviceRepository ?? (_serviceRepository = new GenericRepository<R8>(_db)); }
        }

        public GenericRepository<R9> ProjectRepository
        {
            get { return _projectRepository ?? (_projectRepository = new GenericRepository<R9>(_db)); }
        }

        public GenericRepository<Unit> UnitRepository
        {
            get { return _unitRepository ?? (_unitRepository = new GenericRepository<Unit>(_db)); }
        }

        public GenericRepository<Txt> TypeOfWorkTextRepository
        {
            get { return _typeOfWorkText ?? (_typeOfWorkText = new GenericRepository<Txt>(_db)); }
        }
    }
}
