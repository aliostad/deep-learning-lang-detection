using DAL.Interfaces;
using DAL.Models;
using DAL.Repository;
using System;

namespace DAL.UnitOfWork
{
    public class UnitOfWork : IUnitOfWork
    {
        private readonly DBEntities _context = new DBEntities();

        private GenericRepository<Client> _userRepository;
        private GenericRepository<Order> _orderRepository;
        private GenericRepository<Product> _productRepository;
        private GenericRepository<Employee> _employeeRepository;
        private GenericRepository<Package> _packageRepository;
        private GenericRepository<Invoice> _invoiceRepository;
        private GenericRepository<Contains> _containsRepository;
        private GenericRepository<RecipeDrug> _recipeDrugRepository;
        private GenericRepository<Manager> _managerRepository;
        private GenericRepository<ManagerStatus> _managerStatusRepository;
        private GenericRepository<PackageStatus> _packageStatusRepository;
        private GenericRepository<OrderStatus> _orderStatusRepository;
        private GenericRepository<Position> _positionRepository;
        private GenericRepository<Ingridient> _ingridientRepository;
        private GenericRepository<Shipping> _shippingRepository;

        public GenericRepository<Client> UserRepository
        {
            get { return _userRepository ?? (_userRepository = new GenericRepository<Client>(_context)); }
        }

        public GenericRepository<Order> OrderRepository
        {
            get { return _orderRepository ?? (_orderRepository = new GenericRepository<Order>(_context)); }
        }

        public GenericRepository<Product> ProductRepository
        {
            get { return _productRepository ?? (_productRepository = new GenericRepository<Product>(_context)); }
        }

        public GenericRepository<Employee> EmployeeRepository
        {
            get { return _employeeRepository ?? (_employeeRepository = new GenericRepository<Employee>(_context)); }
        }

        public GenericRepository<Package> PackageRepository
        {
            get { return _packageRepository ?? (_packageRepository = new GenericRepository<Package>(_context)); }
        }

        public GenericRepository<Invoice> InvoiceRepository
        {
            get { return _invoiceRepository ?? (_invoiceRepository = new GenericRepository<Invoice>(_context)); }
        }

        public GenericRepository<Contains> ContainsRepository
        {
            get { return _containsRepository ?? (_containsRepository = new GenericRepository<Contains>(_context)); }
        }

        public GenericRepository<RecipeDrug> RecipeDrugRepository
        {
            get { return _recipeDrugRepository ?? (_recipeDrugRepository = new GenericRepository<RecipeDrug>(_context)); }
        }

        public GenericRepository<Manager> ManagerRepository
        {
            get { return _managerRepository ?? (_managerRepository = new GenericRepository<Manager>(_context)); }
        }

        public GenericRepository<ManagerStatus> ManagerStatusRepository
        {
            get { return _managerStatusRepository ?? (_managerStatusRepository = new GenericRepository<ManagerStatus>(_context)); }
        }

        public GenericRepository<PackageStatus> PackageStatusRepository
        {
            get { return _packageStatusRepository ?? (_packageStatusRepository = new GenericRepository<PackageStatus>(_context)); }
        }

        public GenericRepository<OrderStatus> OrderStatusRepository
        {
            get { return _orderStatusRepository ?? (_orderStatusRepository = new GenericRepository<OrderStatus>(_context)); }
        }

        public GenericRepository<Position> PositionRepository
        {
            get { return _positionRepository ?? (_positionRepository = new GenericRepository<Position>(_context)); }
        }

        public GenericRepository<Ingridient> IngridientRepository
        {
            get { return _ingridientRepository ?? (_ingridientRepository = new GenericRepository<Ingridient>(_context)); }
        }

        public GenericRepository<Shipping> ShippingRepository
        {
            get { return _shippingRepository ?? (_shippingRepository = new GenericRepository<Shipping>(_context)); }
        }

        public void Save()
        {
            _context.SaveChanges();
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        private bool _disposed;

        protected virtual void Dispose(bool disposing)
        {
            if (!_disposed)
            {
                if (disposing)
                {
                    _context.Dispose();
                }
            }
            _disposed = true;
        }
    }
}
