using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ProjectManagement.DAL;

namespace ProjectManagement.Repository.UnitOfWork
{
    public class UnitOfWork : IUnitOfWork, IDisposable
    {
        private readonly DataContext _context;
        private ICompanyRepository _companyRepository;
        private IProjectRepository _projectRepository;
        //Indu
        private ISprintRepository _sprintRepository;
        //rahul
        private IUserRepository _userRepository;
        private IRoleRepository _roleRepository;
        private IUserRoleRepository _userRoleRepository;
        private IPermissionRepository _permissionRepository;
        private IRolePermissionRepository _rolePermissionRepository;
        //shalini
        private ITaskRepository _taskRepository;
        //Shailesh
        private ICountryRepository _countryRepository;
        private IStateRepository _stateRepository;
        private IIndustryRepository _industryRepository;
        private ISkilRepository _skilRepository;
        private IDesignationRespository _designationRespository;
        private IDepartmentRepository _departmentRepository;

        //Faizan
        private IResourceRepository _resourceRepository;



        public UnitOfWork(DataContext context)
        {
            _context = context;
        }

        public ICompanyRepository CompanyRepository
        {
            get { return _companyRepository ?? (_companyRepository = new CompanyRepository(_context)); }
        }

        public IProjectRepository ProjectRepository
        {
            get
            {
                return _projectRepository ?? (_projectRepository = new ProjectRepository(_context));
            }
        }

        public ISprintRepository SprintRepository
        {
            get
            {
                return _sprintRepository ?? (_sprintRepository = new SprintRepository(_context));
            }
        }

        //rahul
        public IUserRepository UserRepository
        {
            get
            {
                return _userRepository ?? (_userRepository = new UserRepository(_context));
            }
        }

        public IRoleRepository RoleRepository
        {
            get
            {
                return _roleRepository ?? (_roleRepository = new RoleRepository(_context));
            }
        }

        public IUserRoleRepository UserRoleRepository
        {
            get
            {
                return _userRoleRepository ?? (_userRoleRepository = new UserRoleRepository(_context));
            }
        }

        public IPermissionRepository PermissionRepository
        {
            get
            {
                return _permissionRepository ?? (_permissionRepository = new PermissionRepository(_context));
            }
        }

        public IRolePermissionRepository RolePermissionRepository
        {
            get
            {
                return _rolePermissionRepository ?? (_rolePermissionRepository = new RolePermissionRepository(_context));
            }
        }

        //shalini
        public ITaskRepository TaskRepository
        {
            get
            {
                return _taskRepository ?? (_taskRepository = new TaskRepository(_context));
            }
        }

        #region Shailesh
        public ICountryRepository CountryRepository
        {
            get
            {
                return _countryRepository ?? (_countryRepository = new CountryRepository(_context));
            }
        }

        public IStateRepository StateRepository
        {
            get
            {
                return _stateRepository ??
                (_stateRepository = new StateRepository(_context));
            }
        }

        public IIndustryRepository IndustryRepository
        {
            get
            {
                return _industryRepository ?? (_industryRepository = new IndustryRepository(_context));
            }
        }

        public ISkilRepository SkilRepository
        {
            get
            {
                return _skilRepository ?? (_skilRepository = new SkilRepository(_context));
            }
        }
        public IDesignationRespository DesignationRespository
        {
            get
            {
                return _designationRespository ?? (_designationRespository = new DesignationRepository(_context));
            }
        }
        public IDepartmentRepository DepartmentRepository
        {
            get
            {
                return _departmentRepository ?? (_departmentRepository = new DepartmentRepository(_context));
            }
        }



        #endregion


        //Faizan
        public IResourceRepository ResourceRepository
        {
            get
            {
                return _resourceRepository ?? (_resourceRepository = new ResourceRepository(_context));
            }
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
            System.GC.SuppressFinalize(this);
        }
    }
}
