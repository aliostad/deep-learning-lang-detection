using PayrollInformation.Models;
using PayrollInformation.Repository;

namespace PayrollInformation.Infrastructure
{
    public static class ServiceLocator
    {
        private static IEmployeeSalary _employeeSalary;
        private static IEmployeesRepository _employeesRepository;
        private static IRolesRepository _rolesRepository;
        private static ICurrenciesRepository _currenciesRepository;
        private static ISalariesRepository _salariesRepository;
        private static IDisplay _display;

        public static IEmployeeSalary GetEmployeeSalary()
        {
            if(_employeeSalary==null)
                _employeeSalary = new EmployeeSalary();
            return _employeeSalary;
        }
        public static IEmployeesRepository GetEmployeesRepository()
        {
            if (_employeesRepository == null)
                _employeesRepository = new EmployeesRepository();
            return _employeesRepository;
        }
        public static IRolesRepository GetRolesRepository()
        {
            if (_rolesRepository == null)
                _rolesRepository = new RolesRepository();
            return _rolesRepository;
        }
        public static ICurrenciesRepository GetCurrencyRepository()
        {
            if (_currenciesRepository == null)
                _currenciesRepository = new CurrenciesRepository();
            return _currenciesRepository;
        }
        public static ISalariesRepository GetSalaryRepository()
        {
            if (_salariesRepository == null)
                _salariesRepository = new SalariesRepository();
            return _salariesRepository;
        }
        public static IDisplay GetDisplay()
        {
            if (_display == null)
                _display = new Display();
            return _display;
        }
    }
}
