using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SilverDaleSchools.DAL;
using SilverDaleSchools.Model;
using SilverDaleSchool.DAL;
//using System.Data.Objects;

namespace SilverDaleSchools.DAL
{
    public class UnitOfWork : IDisposable
    {
        private sdContext context = new sdContext();
        private StaffRepository staffRepository;
        private StudentRepository studentRepository;
        private ResultRepository resultRepository;
        private PersonRepository personRepository;
        //private PrimarySchoolStaffRepository primarySchoolStafftRepository;
        //private PhotoRepository photoRepository;
        //private SubjectRepository subjectRepository;
        //private StoreRepository storeRepository;
        private LevelRepository levelRepository;
        //private PersonRepository personRepository;
        //private SubjectRegistrationRepository subjectRegistrationRepository;
        //private StudentFeesRepository studentFeesRepository;
        //private ExamRepository examRepository;
        private MyRoleRepository myRoleRepository;
        //private ActivityRepository activityRepository;
        //private SchoolFeePaymentRepository schoolFeePaymentRepository;
        //private OrderItemRepository orderItemRepository;
        //private Exam1Repository exam1Repository;
        //private Exam2Repository exam2Repository;
        //private OrderRepository orderRepository;
        //private OnlineExamRepository onlineExamRepository;
        //private QuestionRepository questionRepository;
        //private ChoiceRepository choiceRepository;
        //private QuestionPhotoRepository questionPhotoRepository;
        //private BlogRepository blogRepository;
        //private PostRepository postRepository;
        //private CommentRepository commentRepository;
        //private InformationRepository informationRepository;
        //private PractiseSaveRepository practiseSaveRepository;
        //private SecondarySchoolStudentRepository secondarySchoolStudentRepository;


        //private PasswordRepository passwordRepository;
        //private AttendanceRepository attendanceRepository; // 
        private NewsBoardRepository newsBoardRepository;

        ////
        //private TeacherRepository teacherRepository;
        //private TeachingClassRepository teachingClassRepository;
        //private TeachingDayRepository teachingDayRepository;
        //private TeachingSubjectRepository teachingSubjectRepository;
        //private TeachingTimeRepository teachingTimeRepository;
        //private AttendanceStaffRepository attendanceStaffRepository;
        //private ParentRepository parentRepository;
        //private AuditTrailRepository auditTrailRepository;
        //private TermRepository termRepository;
        //private AdditionalChapterTextRepository additionalChapterTextRepository;
        //private ChapterRepository chapterRepository;
        //private TextBookRepository textBookRepository;
        //private CourseRepository courseRepository;

        //private RoomRepository roomRepository;
        //private HostelRepository hostelRepository;

        //private SchoolFeesTypeRepository schoolFeesTypeRepository;
        //private TermRegistrationRepository termRegistrationRepository;

        //private SchoolFeesAccountRepository schoolFeesAccountRepository;
        //private SalaryRepository salaryRepository;
        //private DeductionRepository deductionRepository;
        //private LoanRepository loanRepository;

        //private DeductionHistoryRepository deductionHistoryRepository;

        //private LatenessDeductionRepository latenessDeductionRepository;
        //private SalaryPaymentHistoryRepository salaryPaymentHistoryRepository;

        //private SchoolAccountRepository schoolAccountRepository;

        //private AbscentDeductionRepository abscentDeductionRepository;

        //private SupplierRepository supplierRepository;
        //private SupplierOrderRepository supplierOrderRepository;


        public LevelRepository LevelRepository
        {
            get
            {
                if (this.levelRepository == null)
                {
                    this.levelRepository = new LevelRepository(context);
                }
                return levelRepository;
            }
        }

        public NewsBoardRepository NewsBoardRepository
        {
            get
            {
                if (this.newsBoardRepository == null)
                {
                    this.newsBoardRepository = new NewsBoardRepository(context);
                }
                return newsBoardRepository;
            }
        }


        public MyRoleRepository MyRoleRepository
        {
            get
            {
                if (this.myRoleRepository == null)
                {
                    this.myRoleRepository = new MyRoleRepository(context);
                }
                return myRoleRepository;
            }
        }
        public PersonRepository PersonRepository
        {
            get
            {
                if (this.personRepository == null)
                {
                    this.personRepository = new PersonRepository(context);
                }
                return personRepository;
            }
        }

        public ResultRepository ResultRepository
        {
            get
            {
                if (this.resultRepository == null)
                {
                    this.resultRepository = new ResultRepository(context);
                }
                return resultRepository;
            }
        }

        public StudentRepository StudentRepository
        {
            get
            {
                if (this.studentRepository == null)
                {
                    this.studentRepository = new StudentRepository(context);
                }
                return studentRepository;
            }
        }

        public StaffRepository StaffRepository
        {
            get
            {
                if (this.staffRepository == null)
                {
                    this.staffRepository = new StaffRepository(context);
                }
                return staffRepository;
            }
        }


      


        public void Save()
        {
            try
            {
                // context.SaveChanges(SaveOptions.DetectChangesBeforeSave);//</code>

                context.SaveChanges();
            }
            catch (Exception e)
            {
                //  context.r
            }
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
            Dispose(true);
            GC.SuppressFinalize(this);
        }
    }
}
