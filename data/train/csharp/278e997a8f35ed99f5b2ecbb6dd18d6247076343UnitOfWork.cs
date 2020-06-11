using IITAcademicAutomationSystem.Areas.One.Models;
using IITAcademicAutomationSystem.Areas.One.Repositories;
using System;

namespace IITAcademicAutomationSystem.DAL
{
    // Make sure that when you use multiple repositories, they share a single database context.
    // Each repository property returns a repository instance that has been instantiated 
    // using the same database context instance as the other repository instances.
    public class UnitOfWork : IDisposable
    {
        private ApplicationDbContext context = new ApplicationDbContext();

        private IUserRepository userRepository;
        private IRoleRepository roleRepository;
        private IStudentRepository studentRepository;
        private IProgramRepository programRepository;
        private IBatchRepository batchRepository;
        private IBatchCoordinatorRepository batchCoordinatorRepository;
        private ISemesterRepository semesterRepository;
        private ICourseRepository courseRepository;
        private ICourseContentRepository courseContentRepository;
        private ICourseSemesterRepository courseSemesterRepository;
        private IStudentCourseRepository studentCourseRepository;
        private IStudentSemesterRepository studentSemesterRepository;

        public IUserRepository UserRepository
        {
            get
            {
                if (userRepository == null)
                {
                    userRepository = new UserRepository(context);
                }
                return userRepository;
            }
        }
        public IRoleRepository RoleRepository
        {
            get
            {
                if (roleRepository == null)
                {
                    roleRepository = new RoleRepository(context);
                }
                return roleRepository;
            }
        }
        public IStudentRepository StudentRepository
        {
            get
            {
                if (studentRepository == null)
                {
                    studentRepository = new StudentRepository(context);
                }
                return studentRepository;
            }
        }
        public IProgramRepository ProgramRepository
        {
            get
            {
                if (programRepository == null)
                {
                    programRepository = new ProgramRepository(context);
                }
                return programRepository;
            }
        }
        public IBatchRepository BatchRepository
        {
            get
            {
                if (batchRepository == null)
                {
                    batchRepository = new BatchRepository(context);
                }
                return batchRepository;
            }
        }
        public IBatchCoordinatorRepository BatchCoordinatorRepository
        {
            get
            {
                if (batchCoordinatorRepository == null)
                {
                    batchCoordinatorRepository = new BatchCoordinatorRepository(context);
                }
                return batchCoordinatorRepository;
            }
        }
        public ISemesterRepository SemesterRepository
        {
            get
            {
                if (semesterRepository == null)
                {
                    semesterRepository = new SemesterRepository(context);
                }
                return semesterRepository;
            }
        }
        public ICourseRepository CourseRepository
        {
            get
            {
                if (courseRepository == null)
                {
                    courseRepository = new CourseRepository(context);
                }
                return courseRepository;
            }
        }
        public ICourseContentRepository CourseContentRepository
        {
            get
            {
                if (courseContentRepository == null)
                {
                    courseContentRepository = new CourseContentRepository(context);
                }
                return courseContentRepository;
            }
        }
        public ICourseSemesterRepository CourseSemesterRepository
        {
            get
            {
                if (courseSemesterRepository == null)
                {
                    courseSemesterRepository = new CourseSemesterRepository(context);
                }
                return courseSemesterRepository;
            }
        }
        public IStudentCourseRepository StudentCourseRepository
        {
            get
            {
                if (studentCourseRepository == null)
                {
                    studentCourseRepository = new StudentCourseRepository(context);
                }
                return studentCourseRepository;
            }
        }

        public IStudentSemesterRepository StudentSemesterRepository
        {
            get
            {
                if (studentSemesterRepository == null)
                {
                    studentSemesterRepository = new StudentSemesterRepository(context);
                }
                return studentSemesterRepository;
            }
        }
        
        public void Save()
        {
            context.SaveChanges();
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