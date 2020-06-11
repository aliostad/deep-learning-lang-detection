using System.Threading.Tasks;
using DatabaseLayer.Models;
using DatabaseLayer.Repository;
using Microsoft.EntityFrameworkCore;

namespace DatabaseLayer.UoW
{
    public sealed class UnitOfWork : IUnitOfWork
    {
        private readonly DatabaseContext context;
        public static DbContextOptionsBuilder<DatabaseContext> DbContextOptions;
        #region Repositories

        private IGenericRepository<User> userRepository;
        public IGenericRepository<User> UserRepository => userRepository ?? (userRepository = new GenericRepository<User>(context));

        public IGenericRepository<Book> bookRepository;
        public IGenericRepository<Book> BookRepository => bookRepository ?? (bookRepository = new GenericRepository<Book>(context));

        public IGenericRepository<BookProviderClicksLog> bookProviderClicksLogRepository;
        public IGenericRepository<BookProviderClicksLog> BookProviderClicksLogRepository => bookProviderClicksLogRepository ?? (bookProviderClicksLogRepository = new GenericRepository<BookProviderClicksLog>(context));

        public IGenericRepository<Comment> commentRepository;
        public IGenericRepository<Comment> CommentRepository => commentRepository ?? (commentRepository = new GenericRepository<Comment>(context));

        public IGenericRepository<DegreeProgram> degreeProgramRepository;
        public IGenericRepository<DegreeProgram> DegreeProgramRepository => degreeProgramRepository ?? (degreeProgramRepository = new GenericRepository<DegreeProgram>(context));

        public IGenericRepository<EducationDegree> educationDegreeRepository;
        public IGenericRepository<EducationDegree> EducationDegreeRepository => educationDegreeRepository ?? (educationDegreeRepository = new GenericRepository<EducationDegree>(context));

        public IGenericRepository<Notification> notificationRepository;
        public IGenericRepository<Notification> NotificationRepository => notificationRepository ?? (notificationRepository = new GenericRepository<Notification>(context));

        public IGenericRepository<Rating> ratingRepository;
        public IGenericRepository<Rating> RatingRepository => ratingRepository ?? (ratingRepository = new GenericRepository<Rating>(context));
                
        public IGenericRepository<School> schoolRepository;
        public IGenericRepository<School> SchoolRepository => schoolRepository ?? (schoolRepository = new GenericRepository<School>(context));

        public IGenericRepository<SellingBook> sellingBookRepository;
        public IGenericRepository<SellingBook> SellingBookRepository => sellingBookRepository ?? (sellingBookRepository = new GenericRepository<SellingBook>(context));

        public IGenericRepository<Student> studentRepository;
        public IGenericRepository<Student> StudentRepository => studentRepository ?? (studentRepository = new GenericRepository<Student>(context));

        public IGenericRepository<StudyCourse> studyCourseRepository;
        public IGenericRepository<StudyCourse> StudyCourseRepository => studyCourseRepository ?? (studyCourseRepository = new GenericRepository<StudyCourse>(context));

        public IGenericRepository<StudyCourseBook> studyCourseBookRepository;
        public IGenericRepository<StudyCourseBook> StudyCourseBookRepository => studyCourseBookRepository ?? (studyCourseBookRepository = new GenericRepository<StudyCourseBook>(context));

        public IGenericRepository<Wishlist> wishlistRepository;
        public IGenericRepository<Wishlist> WishlistRepository => wishlistRepository ?? (wishlistRepository = new GenericRepository<Wishlist>(context));

        #endregion

        public UnitOfWork()
        {
            this.context = new DatabaseContext(UnitOfWork.DbContextOptions.Options);
        }

        public void Commit()
        {
            context.SaveChanges();
        }

        public Task CommitAsync()
        {
            return context.SaveChangesAsync();
        }

        public void Dispose()
        {
            context.Dispose();
        }
    }
}
