using Falcon.Data.Repositories;

namespace Falcon.Data.Infrastructure
{
    public class UnitOfWork : IUnitOfWork
    {
        IDatabaseFactory dbFactory;

        public UnitOfWork(IDatabaseFactory dbFactory)
        {
            this.dbFactory = dbFactory;
        }
        private FalconDbContext datContext;

        protected FalconDbContext DataContext
        {
            get
            {
                return datContext = dbFactory.DataContext;
            }
        }

        public void Dispose()
        {
            DataContext.Dispose();
        }

        public void Commit()
        {
            DataContext.SaveChanges();
        }

        private IAdminRepository adminRepository;
        public IAdminRepository AdminRepository
        {
            get { return adminRepository = new AdminRepository(dbFactory); }
        }

        private IBankAccountRepository bankAccountRepository;
        public IBankAccountRepository BankAccountRepository
        {
            get { return bankAccountRepository = new BankAccountRepository(dbFactory); }
        }

        private ICategoryRepository categoryRepository;
        public ICategoryRepository CategoryRepository
        {
            get { return categoryRepository = new CategoryRepository(dbFactory); }
        }

        private ICircleRepository circleRepository;
        public ICircleRepository CircleRepository
        {
            get { return circleRepository = new CircleRepository(dbFactory); }
        }

        private IComplaintRepository complaintRepository;
        public IComplaintRepository ComplaintRepository
        {
            get { return complaintRepository = new ComplaintRepository(dbFactory); }
        }

        private ICvRepository cvRepository;
        public ICvRepository CvRepository
        {
            get { return cvRepository = new CvRepository(dbFactory); }
        }

        private IDocumentRepository documentRepository;
        public IDocumentRepository DocumentRepository
        {
            get { return documentRepository = new DocumentRepository(dbFactory); }
        }

        private IEvaluationRepository evaluationRepository;
        public IEvaluationRepository EvaluationRepository
        {
            get { return evaluationRepository = new EvaluationRepository(dbFactory); }
        }

        private IEventRepository eventRepository;
        public IEventRepository EventRepository
        {
            get { return eventRepository = new EventRepository(dbFactory); }
        }

        private IFreelancerRepository freelancerRepository;
        public IFreelancerRepository FreelancerRepository
        {
            get { return freelancerRepository = new FreelancerRepository(dbFactory); }
        }

        private IMemberRepository memberRepository;
        public IMemberRepository MemberRepository
        {
            get { return memberRepository = new MemberRepository(dbFactory); }
        }

        private IMissionRepository missionRepository;
        public IMissionRepository MissionRepository
        {
            get { return missionRepository = new MissionRepository(dbFactory); }
        }

        private IOwnerRepository ownerRepository;
        public IOwnerRepository OwnerRepository
        {
            get { return ownerRepository = new OwnerRepository(dbFactory); }
        }

        private IPostRepository postRepository;
        public IPostRepository PostRepository
        {
            get { return postRepository = new PostRepository(dbFactory); }
        }

        private IPrivateMessageRepository privateMessageRepository;
        public IPrivateMessageRepository PrivateMessageRepository
        {
            get { return privateMessageRepository = new PrivateMessageRepository(dbFactory); }
        }
    }
}
