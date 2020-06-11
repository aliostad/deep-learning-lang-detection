using System;

namespace WarehouseWebApp_v1._0.Models.Repositories
{
    public class UnitOfWork : IDisposable
    {
        private readonly WarehouseAppDomainContext _context = new WarehouseAppDomainContext();
        private IProductRepository _productRepository;
        private IProductGroupRepository _productGroupRepository;
        private IStockTransactionRepository _stockTransactionRepository;
        private IInvoiceRepository _invoiceRepository;
        private IPriceRepository _priceRepository;
        private IContractorRepository _contractorRepository;
        private IInvoiceProductRepository _invoiceProductRepository;


        public IProductRepository ProductRepository
        {
            get
            {
                if (_productRepository == null)
                {
                    _productRepository = new ProductRepository(_context);
                }
                return _productRepository;
            }
        }

        public IProductGroupRepository ProductGroupRepository
        {
            get
            {
                if (_productGroupRepository == null)
                {
                    _productGroupRepository = new ProductGroupRepository(_context);
                }
                return _productGroupRepository;
            }
        }

        public IStockTransactionRepository StockTransactionRepository
        {
            get
            {
                if (_stockTransactionRepository == null)
                {
                    _stockTransactionRepository = new StockTransactionRepository(_context);
                }
                return _stockTransactionRepository;
            }
        }

        public IInvoiceRepository InvoiceRepository
        {
            get
            {
                if (_invoiceRepository == null)
                {
                    _invoiceRepository = new InvoiceRepository(_context);
                }
                return _invoiceRepository;
            }
        }

        public IPriceRepository PriceRepository
        {
            get
            {
                if (_priceRepository == null)
                {
                    _priceRepository = new PriceRepository(_context);
                }
                return _priceRepository;
            }
        }

        public IContractorRepository ContractorRepository
        {
            get
            {
                if (_contractorRepository == null)
                {
                    _contractorRepository = new ContractorRepository(_context);
                }
                return _contractorRepository;
            }
        }

        public IInvoiceProductRepository InvoiceProductRepository
        {
            get
            {
                if (_invoiceProductRepository == null)
                {
                    _invoiceProductRepository = new InvoiceProductRepository(_context);
                }
                return _invoiceProductRepository;
            }
        }

        public bool Save()
        {
            return _context.SaveChanges() > 0;
        }

        //Dispose pattern
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

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
    }
}
