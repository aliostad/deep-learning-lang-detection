using System.Data.Entity;
using DAL.Interfacies.Concrete;

namespace DAL.Concrete
{
    public class UnitOfWork : IUnitOfWork
    {
        public DbContext Context { get; private set; }

        private ClassRoomRepository classRoomRepository;
        private CommentRepository commentRepository;
        private MailRepository mailRepository;
        private ParentRepository parentRepository;
        private PupilRepository pupilRepository;
        private RequisitionRepository requisitionRepository;
        private RoleRepository roleRepository;
        private TeacherRepository teacherRepository;
        private UserRepository userRepository;

        public IClassRoomRepository ClassRoomRepository => classRoomRepository ?? new ClassRoomRepository(Context);
        public ICommentRepository CommentRepository => commentRepository ?? new CommentRepository(Context);
        public IMailRepository MailRepository => mailRepository ?? new MailRepository(Context);
        public IParentRepository ParentRepository => parentRepository ?? new ParentRepository(Context);
        public IPupilRepository PupilRepository => pupilRepository ?? new PupilRepository(Context);
        public IRequisitionRepository RequisitionRepository
            => requisitionRepository ?? new RequisitionRepository(Context);
        public IRoleRepository RoleRepository => roleRepository ?? new RoleRepository(Context);
        public ITeacherRepository TeacherRepository => teacherRepository ?? new TeacherRepository(Context);
        public IUserRepository UserRepository => userRepository ?? new UserRepository(Context);


        public UnitOfWork(DbContext context, ClassRoomRepository classRoomRepository, CommentRepository commentRepository, MailRepository mailRepository, ParentRepository parentRepository, PupilRepository pupilRepository, RequisitionRepository requisitionRepository, RoleRepository roleRepository, TeacherRepository teacherRepository, UserRepository userRepository)
        {
            Context = context;
            this.classRoomRepository = classRoomRepository;
            this.commentRepository = commentRepository;
            this.mailRepository = mailRepository;
            this.parentRepository = parentRepository;
            this.pupilRepository = pupilRepository;
            this.requisitionRepository = requisitionRepository;
            this.roleRepository = roleRepository;
            this.teacherRepository = teacherRepository;
            this.userRepository = userRepository;
        }

        public void Saving() => Context?.SaveChanges();

        public void Dispose() => Context?.Dispose();

    }
}
