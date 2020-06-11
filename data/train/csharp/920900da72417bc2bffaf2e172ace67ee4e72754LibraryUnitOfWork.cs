using Library.AppContext;
using Library.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Library.UnitOfWork
{
    public static class LibraryUnit
    {
        static ApplicationDbContext _context;
        public static AuthorRepository AuthorRepository { get; private set; }
        public static BookRepository BookRepository { get; private set; }
        public static CategoryRepository CategoryRepository { get; private set; }
        public static PressRepository PressRepository { get; private set; }
        public static ThemeRepository ThemeRepository { get; private set; }
        public static DepartmentRepository DepartmentRepository { get; private set; }
        public static TeacherRepository TeacherRepository { get; private set; }
        public static FacultyRepository FacultyRepository { get; private set; }
        public static GroupRepository GroupRepository { get; private set; }
        public static StudentRepository StudentRepository { get; private set; }
        public static SCardRepository SCardRepository { get; private set; }
        public static TCardRepository TCardRepository { get; private set; }
        public static LibrarianRepository LibrarianRepository { get; private set; }

        static LibraryUnit()
        {
            _context = new ApplicationDbContext("Library");

            AuthorRepository = new AuthorRepository(_context);
            BookRepository = new BookRepository(_context);
            CategoryRepository = new CategoryRepository(_context);
            PressRepository = new PressRepository(_context);
            ThemeRepository =new ThemeRepository(_context);
            DepartmentRepository = new DepartmentRepository(_context);
            TeacherRepository = new TeacherRepository(_context);
            FacultyRepository = new FacultyRepository(_context);
            GroupRepository = new GroupRepository(_context);
            StudentRepository =new StudentRepository(_context);
            SCardRepository =new SCardRepository(_context);
            TCardRepository =new TCardRepository(_context);
            LibrarianRepository=new LibrarianRepository(_context);
        }
    }
}
