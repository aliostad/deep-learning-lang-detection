using ShopManager.DAL.Abstraction.Repositories;
using ShopManager.DAL.Abstraction.UnitOfWork;
using ShopManager.DAL.Concrete.Repositories;

namespace ShopManager.DAL.Concrete.UnitOfWork
{
    public class UnitOfWork:IUnitOfWork
    {
        protected readonly string _connection;
        protected IEmployeeRepository _employeeRepository;
        protected IProductRepository _productRepository;
        protected IRealizationRepozitory _realizationRepository;
        private ISaleRepository _saleRepository;
        private IStringRepository _stringRepository;
        public UnitOfWork(string connection)
        {
            _connection = connection;
        }
        public IEmployeeRepository EmployeeRepository
        {
            get { return _employeeRepository ?? (_employeeRepository = new EmployeeRepository(_connection)); }
        }
        public IProductRepository ProductRepository
        {
            get { return _productRepository ?? (_productRepository = new ProductRepository(_connection)); }
        }
        public IRealizationRepozitory RealizationRepository
        {
            get { return _realizationRepository ?? (_realizationRepository = new RealizationRepository(_connection)); }
        }
        public ISaleRepository SalesRepository
        {
            get { return _saleRepository ?? (_saleRepository = new SalesRepository(_connection)); }
        }
        public IStringRepository StringRepository
        {
            get { return _stringRepository ?? (_stringRepository = new StringRepository(_connection)); }
        }
    }
}
