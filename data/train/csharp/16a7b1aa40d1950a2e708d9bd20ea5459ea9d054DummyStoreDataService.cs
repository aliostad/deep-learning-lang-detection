using MvvM_Appie.Model.Interfaces;
using MvvM_Appie.Model.Models;

namespace MvvM_Appie.Model.DataService.DummyServiceLocator
{
    public class DummyStoreDataService : IStoreDataService
    {
        private readonly IGenericRepository<Afdeling> _afdelingRepository;
        private readonly IGenericRepository<Coupon> _couponRepository;
        private readonly IGenericRepository<Merk> _merkRepository;
        private readonly IGenericRepository<MerkProduct> _merkProductRepository;
        private readonly IGenericRepository<Product> _productRepository;
        private readonly IGenericRepository<Recept> _receptRepository;
        private readonly IGenericRepository<ReceptMerkProduct> _receptMerkProductRepository;

        public DummyStoreDataService(
            IGenericRepository<Afdeling> afdelingRepository, IGenericRepository<Coupon> couponRepository, IGenericRepository<Merk> merkRepository,
            IGenericRepository<MerkProduct> merkProductRepository, IGenericRepository<Product> productRepository,
            IGenericRepository<Recept> receptRepository, IGenericRepository<ReceptMerkProduct> receptMerkProductRepository)
        {
            _afdelingRepository = afdelingRepository;
            _couponRepository = couponRepository;
            _merkRepository = merkRepository;
            _merkProductRepository = merkProductRepository;
            _productRepository = productRepository;
            _receptRepository = receptRepository;
            _receptMerkProductRepository = receptMerkProductRepository;
        }

        public IGenericRepository<Afdeling> AfdelingRepository
        {
            get
            {
                return _afdelingRepository;
            }
        }

        public IGenericRepository<Coupon> CouponRepository
        {
            get
            {
                return _couponRepository;
            }
        }

        public IGenericRepository<Merk> MerkRepository
        {
            get
            {
                return _merkRepository;
            }
        }

        public IGenericRepository<MerkProduct> MerkProductRepository
        {
            get
            {
                return _merkProductRepository;
            }
        }

        public IGenericRepository<Product> ProductRepository
        {
            get
            {
                return _productRepository;
            }
        }

        public IGenericRepository<Recept> ReceptRepository
        {
            get
            {
                return _receptRepository;
            }
        }

        public IGenericRepository<ReceptMerkProduct> ReceptMerkProductRepository
        {
            get
            {
                return _receptMerkProductRepository;
            }
        }


        public void WriteAndClose()
        {
            //
            // Niet Nodig voor DummyData
            //
        }
    }
}
