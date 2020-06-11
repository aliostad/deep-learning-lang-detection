using Employees.DAL.Entities;

namespace Employees.DAL.Repositories
{
    public interface IEmployeeUnitOfWork
    {
        UserGroupRepository UserGroupRepository { get; }
        UserRepository UserRepository { get; }
        PermissionKeyRepository PermissionKeyRepository { get; }

        EmployeeRepository EmployeeRepository { get; }
    }

    public class EmployeeUnitOfWork : IEmployeeUnitOfWork
    {
        private readonly EmployeeRepository _employeeRepository;
        private readonly UserGroupRepository _userGroupRepository;
        private readonly UserRepository _userRepository;
        private readonly PermissionKeyRepository _permissionKeyRepository;


        public EmployeeUnitOfWork(EmployeeRepository employeeRepository,
            UserGroupRepository userGroupRepository,
            UserRepository userRepository,
            PermissionKeyRepository permissionKeyRepository)
        {
            _employeeRepository = employeeRepository;
            _userGroupRepository = userGroupRepository;
            _userRepository = userRepository;
            _permissionKeyRepository = permissionKeyRepository;
        }


        public EmployeeRepository EmployeeRepository
        {
            get { return _employeeRepository; }
        }

        public UserGroupRepository UserGroupRepository
        {
            get { return _userGroupRepository; }
        }

        public UserRepository UserRepository
        {
            get { return _userRepository; }
        }

        public PermissionKeyRepository PermissionKeyRepository
        {
            get { return _permissionKeyRepository; }
        }
    }
}