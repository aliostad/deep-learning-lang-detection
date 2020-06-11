using CMP.Operation.DAL.Repositories.Memory;
using CMP.Operation.DAL.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CMP.Operation.Models
{
    public class RepositoryContainer : IDisposable
    {
        private EmployeeRepository _EmployeeRepository;
        public IEmployeeRepository EmployeeRepository
        {
            get
            {
                if (_EmployeeRepository == null)
                    _EmployeeRepository = new EmployeeRepository();
                return _EmployeeRepository;
            }
        }

        private JobRepository _JobRepository;
        public IJobRepository JobRepository
        {
            get
            {
                if (_JobRepository == null)
                    _JobRepository = new JobRepository();
                return _JobRepository;
            }
        }

        private CustomerRepository _CustomerRepository;
        public ICustomerRepository CustomerRepository
        {
            get
            {
                if (_CustomerRepository == null)
                    _CustomerRepository = new CustomerRepository();
                return _CustomerRepository;
            }
        }


        private DepartmentRepository _DepartmentRepository;
        public IDepartmentRepository DepartmentRepository
        {
            get
            {
                if (_DepartmentRepository == null)
                    _DepartmentRepository = new DepartmentRepository();
                return _DepartmentRepository;
            }
        }


        private FocalPointRepository _FocalPointRepository;
        public IFocalPointRepository FocalPointRepository
        {
            get
            {
                if (_FocalPointRepository == null)
                    _FocalPointRepository = new FocalPointRepository();
                return _FocalPointRepository;
            }
        }


        private ProjectTypeRepository _ProjectTypeRepository;
        public IProjectTypeRepository ProjectTypeRepository
        {
            get
            {
                if (_ProjectTypeRepository == null)
                    _ProjectTypeRepository = new ProjectTypeRepository();
                return _ProjectTypeRepository;
            }
        }

        private TechnologyRepository _TechnologyRepository;
        public ITechnologyRepository TechnologyRepository
        {
            get
            {
                if (_TechnologyRepository == null)
                    _TechnologyRepository = new TechnologyRepository();
                return _TechnologyRepository;
            }
        }
        private ProjectRepository _ProjectRepository;
        public IProjectRepository ProjectRepository
        {
            get
            {
                if (_ProjectRepository == null)
                    _ProjectRepository = new ProjectRepository();
                return _ProjectRepository;
            }
        }
        private ProjectTechnologyRepository _ProjectTechnologyRepository;
        public IProjectTechnologyRepository ProjectTechnologyRepository
        {
            get
            {
                if (_ProjectTechnologyRepository == null)
                    _ProjectTechnologyRepository = new ProjectTechnologyRepository();
                return _ProjectTechnologyRepository;
            }
        }
        private ExperienceRepository _ExperienceRepository;
        public IExperienceRepository ExperienceRepository
        {
            get
            {
                if (_ExperienceRepository == null)
                    _ExperienceRepository = new ExperienceRepository();
                return _ExperienceRepository;
            }
        }
        private ExperienceTechnologyRepository _ExperienceTechnologyRepository;
        public IExperienceTechnologyRepository ExperienceTechnologyRepository
        {
            get
            {
                if (_ExperienceTechnologyRepository == null)
                    _ExperienceTechnologyRepository = new ExperienceTechnologyRepository();
                return _ExperienceTechnologyRepository;
            }
        }
        private CountryRepository _CountryRepository;
        public ICountryRepository CountryRepository
        {
            get
            {
                if (_CountryRepository == null)
                    _CountryRepository = new CountryRepository();
                return _CountryRepository;
            }
        }

        private StateRepository _StateRepository;
        public IStateRepository StateRepository
        {
            get
            {
                if (_StateRepository == null)
                    _StateRepository = new StateRepository();
                return _StateRepository;
            }
        }

        private CityRepository _CityRepository;
        public ICityRepository CityRepository
        {
            get
            {
                if (_CityRepository == null)
                    _CityRepository = new CityRepository();
                return _CityRepository;
            }
        }

        private CompanyRepository _CompanyRepository;
        public ICompanyRepository CompanyRepository
        {
            get
            {
                if (_CompanyRepository == null)
                    _CompanyRepository = new CompanyRepository();
                return _CompanyRepository;
            }
        }

        private UserRepository _UserRepository;
        public IUserRepository UserRepository
        {
            get
            {
                if (_UserRepository == null)
                    _UserRepository = new UserRepository();
                return _UserRepository;
            }
        }

        private RoleRepository _RoleRepository;
        public IRoleRepository RoleRepository
        {
            get
            {
                if (_RoleRepository == null)
                    _RoleRepository = new RoleRepository();
                return _RoleRepository;
            }
        }
        public void Dispose()
        {
            if (_EmployeeRepository != null) _EmployeeRepository.Dispose();
            if (_JobRepository != null) _JobRepository.Dispose();
            if (_CustomerRepository != null) _CustomerRepository.Dispose();
            if (_DepartmentRepository != null) _DepartmentRepository.Dispose();
            if (_FocalPointRepository != null) _FocalPointRepository.Dispose();
            if (_ProjectTypeRepository != null) _ProjectTypeRepository.Dispose();
            if (_TechnologyRepository != null) _TechnologyRepository.Dispose();
            if (_ProjectRepository != null) _ProjectRepository.Dispose();
            if (_ProjectTechnologyRepository != null) _ProjectTechnologyRepository.Dispose();
            if (_ExperienceRepository != null) _ExperienceRepository.Dispose();
            if (_ExperienceTechnologyRepository != null) _ExperienceTechnologyRepository.Dispose();
            if (_CompanyRepository != null) _CompanyRepository.Dispose();
            if (_UserRepository != null) _UserRepository.Dispose();
            if (_RoleRepository != null) _RoleRepository.Dispose();
        }
    }
}