using _01_DataAccessLayer.ClassRepository;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _01_DataAccessLayer
{
    public class UnitOfWork
    {
        TaskManagementContext _context;
        public UnitOfWork()
        {
            _context = new TaskManagementContext();
        }


        CustomerRepository _customerRepository;
        public CustomerRepository CustomerRepository
        {
            get
            {
                if (_customerRepository == null)
                {
                    _customerRepository = new CustomerRepository(_context);
                }
                return _customerRepository;
            }
        }

        CustomerRequestRepository _customerRequestRepository;
        public CustomerRequestRepository CustomerRequestRepository
        {
            get
            {
                if (_customerRequestRepository == null)
                {
                    _customerRequestRepository = new CustomerRequestRepository(_context);
                }
                return _customerRequestRepository;
            }
        }

        EmployeeRepository _employeeRepository;
        public EmployeeRepository EmployeeRepository
        {
            get
            {
                if (_employeeRepository == null)
                {
                    _employeeRepository = new EmployeeRepository(_context);
                }
                return _employeeRepository;
            }
        }

        EmployeeTypeRepository _employeeTypeRepository;
        public EmployeeTypeRepository EmployeeTypeRepository
        {
            get
            {
                if (_employeeTypeRepository == null)
                {
                    _employeeTypeRepository = new EmployeeTypeRepository(_context);
                }
                return _employeeTypeRepository;
            }
        }

        ProjectRepository _projectRepository;
        public ProjectRepository ProjectRepository
        {
            get
            {
                if (_projectRepository == null)
                {
                    _projectRepository = new ProjectRepository(_context);
                }
                return _projectRepository;
            }
        }

        StatusRepository _statusRepository;
        public StatusRepository StatusRepository
        {
            get
            {
                if (_statusRepository == null)
                {
                    _statusRepository = new StatusRepository(_context);
                }
                return _statusRepository;
            }
        }

        TasksRepository _tasksRepository;
        public TasksRepository TasksRepository
        {
            get
            {
                if (_tasksRepository == null)
                {
                    _tasksRepository = new TasksRepository(_context);
                }
                return _tasksRepository;
            }
        }

        ProjectEmployeesRepository _projectEmployeesRepository;
        public ProjectEmployeesRepository ProjectEmployeesRepository
        {
            get
            {
                if (_projectEmployeesRepository == null)
                {
                    _projectEmployeesRepository = new ProjectEmployeesRepository(_context);
                }
                return _projectEmployeesRepository;
            }
        }


        DbContextTransaction _tran;
        public bool ApplyChanges()
        {

            bool isSucces = true;
            _tran = _context.Database.BeginTransaction(System.Data.IsolationLevel.ReadCommitted); 

            try
            {
                _context.SaveChanges();
                _tran.Commit(); 
                isSucces = true;
            }
            catch (Exception)
            {
                _tran.Rollback();
                isSucces = false;
            }
            finally
            {
                _tran.Dispose();
            }

            return isSucces;
        }

    }
}
