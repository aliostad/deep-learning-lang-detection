using System;

namespace Merchant.DataAccess.Repository
{
    public class UnitOfWork : IDisposable
    {
        private MerchantDBEntities1 _context = new MerchantDBEntities1();
        private GenericRepository<Buyer> _buyerRepository;
        private GenericRepository<Insurance> _insuranceRepository;

        private GenericRepository<InsurancePolicy> _insurancePolicyRepository;
        private GenericRepository<Insurants> _insurantsRepository;
        private GenericRepository<Person> _personRepository;
        private GenericRepository<Pricelist> _pricelistRepository;
        private GenericRepository<PricelistItem> _pricelistItemRepository;
        private GenericRepository<PricelistItems> _pricelistItemsRepository;
        private GenericRepository<ResidentalBuilding> _residentialBuildingRepository;
        private GenericRepository<Risk> _riskRepository;
        private GenericRepository<RiskCategory> _riskCategoryRepository;
        private GenericRepository<RiskItem> _riskItemRepository;
        private GenericRepository<Vehicle> _vehicleRepository;


        public GenericRepository<Buyer> BuyerRepository => _buyerRepository ?? (_buyerRepository = new GenericRepository<Buyer>(_context));
        public GenericRepository<Insurance> InsuranceRepository => _insuranceRepository ?? (_insuranceRepository = new GenericRepository<Insurance>(_context));
        public GenericRepository<InsurancePolicy> InsurancePolicyRepository => _insurancePolicyRepository ?? (_insurancePolicyRepository = new GenericRepository<InsurancePolicy>(_context));
        public GenericRepository<Insurants> InsurantsRepository => _insurantsRepository ?? (_insurantsRepository = new GenericRepository<Insurants>(_context));
        public GenericRepository<Person> PersonRepository => _personRepository ?? (_personRepository = new GenericRepository<Person>(_context));
        public GenericRepository<Pricelist> PricelistRepository => _pricelistRepository ?? (_pricelistRepository = new GenericRepository<Pricelist>(_context));
        public GenericRepository<PricelistItem> PricelistItemRepository => _pricelistItemRepository ?? (_pricelistItemRepository = new GenericRepository<PricelistItem>(_context));
        public GenericRepository<PricelistItems> PricelistItemsRepository => _pricelistItemsRepository ?? (_pricelistItemsRepository = new GenericRepository<PricelistItems>(_context));
        public GenericRepository<ResidentalBuilding> ResidentialBuildingRepository => _residentialBuildingRepository ?? (_residentialBuildingRepository = new GenericRepository<ResidentalBuilding>(_context));
        public GenericRepository<Risk> RiskRepository => _riskRepository ?? (_riskRepository = new GenericRepository<Risk>(_context));
        public GenericRepository<RiskCategory> RiskCategoryRepository => _riskCategoryRepository ?? (_riskCategoryRepository = new GenericRepository<RiskCategory>(_context));
        public GenericRepository<RiskItem> RiskItemRepository => _riskItemRepository ?? (_riskItemRepository = new GenericRepository<RiskItem>(_context));
        public GenericRepository<Vehicle> VehicleRepository => _vehicleRepository ?? (_vehicleRepository = new GenericRepository<Vehicle>(_context));

        public void Save()
        {
            _context.SaveChanges();
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

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
    }
}
