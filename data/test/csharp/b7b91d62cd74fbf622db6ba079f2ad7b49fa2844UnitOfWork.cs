using System;
using RepositoryPattern.Repository;

namespace RepositoryPattern
{
    public class UnitOfWork
    {
        private AppraisalDbContext context = new AppraisalDbContext();
        private Repository<Department> _departmentRepository;
        private Repository<DepartmentConfig> _departmentConfigRepository;
        private Repository<Designation> _designationRepository;
        private Repository<DirectorActivities> _directorActivitiesRepository;
        private Repository<Employee> _employeeRepository;
        private Repository<FiscalYear> _fiscalYearRepository; 
        private Repository<HeadOfBusinessUnit> _headOfBusinessUnitRepository; 
        private Repository<JobDescription> _jobDescriptionRepository; 
        private Repository<ObjectiveMain> _objectiveMainRepository; 
        private Repository<ObjectiveSub> _objectiveSubRepository; 
        private Repository<PerformanceAppraisal> _performanceAppraisalRepository; 
        private Repository<Section> _sectionRepository;
        private Repository<Increament> _increamentRepository;
        private Repository<AspNetUsers> _aspNetUsersRepository;
        private Repository<EmployeeSummery> _employeeSummeryRepository;
        private Repository<Company> _compnayRepository;


        public Repository<Company> CompanyRepository => _compnayRepository ?? (_compnayRepository = new Repository<Company>(context));
        public Repository<EmployeeSummery> EmployeeSummeryRepository => _employeeSummeryRepository ?? (_employeeSummeryRepository = new Repository<EmployeeSummery>(context));

        public Repository<AspNetUsers> AspNetUsersRepository
        {
            get
            {

                if (_aspNetUsersRepository == null)
                {
                    _aspNetUsersRepository = new Repository<AspNetUsers>(context);
                }
                return _aspNetUsersRepository;
            }
        }
        public Repository<Department> DepartmentRepository
        {
            get
            {

                if (_departmentRepository == null)
                {
                    _departmentRepository = new Repository<Department>(context);
                }
                return _departmentRepository;
            }
        }
        public Repository<Increament> IncreamentRepository
        {
            get
            {

                if (_increamentRepository == null)
                {
                    _increamentRepository = new Repository<Increament>(context);
                }
                return _increamentRepository;
            }
        }
        public Repository<DepartmentConfig> DepartmentConfigRepository
        {
            get
            {

                if (_departmentConfigRepository == null)
                {
                    _departmentConfigRepository = new Repository<DepartmentConfig>(context);
                }
                return _departmentConfigRepository;
            }
        }
        public Repository<Designation> DesignationRepository
        {
            get
            {

                if (_designationRepository == null)
                {
                    _designationRepository = new Repository<Designation>(context);
                }
                return _designationRepository;
            }
        }
        public Repository<DirectorActivities> DirectorActivitiesRepository
        {
            get
            {

                if (_directorActivitiesRepository == null)
                {
                    _directorActivitiesRepository = new Repository<DirectorActivities>(context);
                }
                return _directorActivitiesRepository;
            }
        }
        public Repository<Employee> EmployeeRepository
        {
            get
            {

                if (_employeeRepository == null)
                {
                    _employeeRepository = new Repository<Employee>(context);
                }
                return _employeeRepository;
            }
        }
        public Repository<FiscalYear> FiscalYearRepository
        {
            get
            {

                if (_fiscalYearRepository == null)
                {
                    _fiscalYearRepository = new Repository<FiscalYear>(context);
                }
                return _fiscalYearRepository;
            }
        }
        public Repository<HeadOfBusinessUnit> HeadOfBusinessUnitRepository
        {
            get
            {

                if (_headOfBusinessUnitRepository == null)
                {
                    _headOfBusinessUnitRepository = new Repository<HeadOfBusinessUnit>(context);
                }
                return _headOfBusinessUnitRepository;
            }
        }
        public Repository<JobDescription> JobDescriptionRepository
        {
            get
            {

                if (_jobDescriptionRepository == null)
                {
                    _jobDescriptionRepository = new Repository<JobDescription>(context);
                }
                return _jobDescriptionRepository;
            }
        }
        public Repository<ObjectiveMain> ObjectiveMainRepository
        {
            get
            {

                if (_objectiveMainRepository == null)
                {
                    _objectiveMainRepository = new Repository<ObjectiveMain>(context);
                }
                return _objectiveMainRepository;
            }
        }
        public Repository<ObjectiveSub> ObjectiveSubRepository
        {
            get
            {

                if (_objectiveSubRepository == null)
                {
                    _objectiveSubRepository = new Repository<ObjectiveSub>(context);
                }
                return _objectiveSubRepository;
            }
        }
        public Repository<PerformanceAppraisal> PerformanceAppraisalRepository
        {
            get
            {

                if (_performanceAppraisalRepository == null)
                {
                    _performanceAppraisalRepository = new Repository<PerformanceAppraisal>(context);
                }
                return _performanceAppraisalRepository;
            }
        }
        public Repository<Section> SectionRepository
        {
            get
            {

                if (_sectionRepository == null)
                {
                    _sectionRepository = new Repository<Section>(context);
                }
                return _sectionRepository;
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
