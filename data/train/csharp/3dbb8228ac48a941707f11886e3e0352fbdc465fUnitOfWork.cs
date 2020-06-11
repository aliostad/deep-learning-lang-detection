using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eLibrary.DAL
{
    public class UnitOfWork : IDisposable
    {
        private eLContext context = new eLContext();

        private CourseRepository courseRepository;
      //  private CourseRepository courseRepository;
        private LevelRepository levelRepository;
        private ChapterRepository chapterRepository;
        private TextBookRepository textBookRepository;
        private AdditionalChapterTextRepository additionalChapterTextRepository;
        private LibraryUserRepository libraryUserRepository;
        private QuestionRepository questionRepository;
        private ExamRepository examRepository;
        private ChoiceRepository choiceRepository;
        private BookRepository bookRepository;
        private ColumnRepository columnRepository;
        private RowRepository rowRepository;
        private ShelfRepository shelfRepository;
        private SubjectAreaRepository subjectAreaRepository;
        private PhotoRepository photoRepository;
        private BorrowedItemRepository borrowedItemRepository;
        private MyRoleRepository myRoleRepository;
        private UserPhotoRepository userPhotoRepository;
        private FinanceRepository financeRepository;


        public FinanceRepository FinanceRepository
        {
            get
            {
                if (this.financeRepository == null)
                {
                    this.financeRepository = new FinanceRepository(context);
                }
                return financeRepository;
            }

        }

        public UserPhotoRepository UserPhotoRepository
        {
            get
            {
                if (this.userPhotoRepository == null)
                {
                    this.userPhotoRepository = new UserPhotoRepository(context);
                }
                return userPhotoRepository;
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
        


        public BorrowedItemRepository BorrowedItemRepository
        {
            get
            {
                if (this.borrowedItemRepository == null)
                {
                    this.borrowedItemRepository = new BorrowedItemRepository(context);
                }
                return borrowedItemRepository;
            }

        }

        public PhotoRepository PhotoRepository
        {
            get
            {
                if (this.photoRepository == null)
                {
                    this.photoRepository = new PhotoRepository(context);
                }
                return photoRepository;
            }

        }


        public SubjectAreaRepository SubjectAreaRepository
        {
            get
            {
                if (this.subjectAreaRepository == null)
                {
                    this.subjectAreaRepository = new SubjectAreaRepository(context);
                }
                return subjectAreaRepository;
            }

        }

        public ShelfRepository ShelfRepository
        {
            get
            {
                if (this.shelfRepository == null)
                {
                    this.shelfRepository = new ShelfRepository(context);
                }
                return shelfRepository;
            }

        }

        public RowRepository RowRepository
        {
            get
            {
                if (this.rowRepository == null)
                {
                    this.rowRepository = new RowRepository(context);
                }
                return rowRepository;
            }

        }

        public ColumnRepository ColumnRepository
        {
            get
            {
                if (this.columnRepository == null)
                {
                    this.columnRepository = new ColumnRepository(context);
                }
                return columnRepository;
            }

        }


        public BookRepository BookRepository
        {
            get
            {
                if (this.bookRepository == null)
                {
                    this.bookRepository = new BookRepository(context);
                }
                return bookRepository;
            }

        }




        public LibraryUserRepository LibraryUserRepository
        {
            get
            {
                if (this.libraryUserRepository == null)
                {
                    this.libraryUserRepository = new LibraryUserRepository(context);
                }
                return libraryUserRepository;
            }

        }


        public ChoiceRepository ChoiceRepository
        {
            get
            {
                if (this.choiceRepository == null)
                {
                    this.choiceRepository = new ChoiceRepository(context);
                }
                return choiceRepository;
            }

        }


      

        public ExamRepository ExamRepository
        {
            get
            {
                if (this.examRepository == null)
                {
                    this.examRepository = new ExamRepository(context);
                }
                return examRepository;
            }

        }

        public QuestionRepository QuestionRepository
        {
            get
            {
                if (this.questionRepository == null)
                {
                    this.questionRepository = new QuestionRepository(context);
                }
                return questionRepository;
            }

        }

        public TextBookRepository TextBookRepository
        {
            get
            {
                if (this.textBookRepository == null)
                {
                    this.textBookRepository = new TextBookRepository(context);
                }
                return textBookRepository;
            }

        }

        public AdditionalChapterTextRepository AdditionalChapterTextRepository
        {
            get
            {
                if (this.additionalChapterTextRepository == null)
                {
                    this.additionalChapterTextRepository = new AdditionalChapterTextRepository(context);
                }
                return additionalChapterTextRepository;
            }

        }

        public ChapterRepository ChapterRepository
        {
            get
            {
                if (this.chapterRepository == null)
                {
                    this.chapterRepository = new ChapterRepository(context);
                }
                return chapterRepository;
            }

        }

        public LevelRepository LevelRepository
        {
            get
            {
                if (this.courseRepository == null)
                {
                    this.levelRepository = new LevelRepository(context);
                }
                return levelRepository;
            }

        }

        public CourseRepository CourseRepository
        {
            get
            {
                if (this.courseRepository == null)
                {
                    this.courseRepository = new CourseRepository(context);
                }
                return courseRepository;
            }
           
        }


        public void Save()
        {
            try
            {

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
