using QuanLyBanHang.Common.DbHelper;
using QuanLyBanHang.Data.MongoDb.Business;
using QuanLyBanHang.Data.MongoDb.Repository;

namespace QuanLyBanHang.Data.MongoDb
{
    public class UnitOfWork
    {
        private AgencyRepository _agencyRepository;

        private UserRepository _userRepository;

        private UserGroupRepository _userGroupRepository;

        private PermissionRepository _permissionRepository;

        private UserGroupPermissionRepository _userGroupPermissionRepository;

        private UserUserGroupRepository _userUserGroupRepository;

        private PassengerRepository _passengerRepository;

        private ProductRepository _productRepository;

        private OrderRepository _orderRepository;

        private ShipmentRepository _shipmentRepository;

        private CostTypeRepository _costTypeRepository;

        private CostRepository _costRepository;

        private PackageRepository _packageRepository;

        private CompanyRepository _companyRepository;

        private ExchangeRateRepository _exchangeRateRepository;

        public UnitOfWork(MongoHelper helper)
        {
            DataHelper = helper;
        }

        public MongoHelper DataHelper { get; set; }

        public AgencyRepository AgencyRepository => _agencyRepository ?? (_agencyRepository = new AgencyRepository(DataHelper,
                                                                                                                 Agency.COLLECTIONNAME));

        public ExchangeRateRepository ExchangeRateRepository => _exchangeRateRepository ?? (_exchangeRateRepository = new ExchangeRateRepository(DataHelper,
                                                                                                                                                 ExchangeRate.COLLECTIONNAME));

        public UserRepository UserRepository => _userRepository ?? (_userRepository = new UserRepository(DataHelper,
                                                                                                         User.COLLECTIONNAME));

        public UserGroupRepository UserGroupRepository => _userGroupRepository ?? (_userGroupRepository = new UserGroupRepository(DataHelper,
                                                                                                                                  UserGroup.COLLECTIONNAME));

        public PermissionRepository PermissionRepository => _permissionRepository ?? (_permissionRepository = new PermissionRepository(DataHelper,
                                                                                                                                  Permission.COLLECTIONNAME));

        public UserGroupPermissionRepository UserGroupPermissionRepository => _userGroupPermissionRepository ?? (_userGroupPermissionRepository = new UserGroupPermissionRepository(DataHelper,
                                                                                                                                                                                    UserGroupPermission.COLLECTIONNAME));

        public UserUserGroupRepository UserUserGroupRepository => _userUserGroupRepository ?? (_userUserGroupRepository = new UserUserGroupRepository(DataHelper,
                                                                                                                                                      UserUserGroup.COLLECTIONNAME));

        public PassengerRepository PassengerRepository => _passengerRepository ?? (_passengerRepository = new PassengerRepository(DataHelper,
                                                                                                                                  Passenger.COLLECTIONNAME));

        public ProductRepository ProductRepository => _productRepository ?? (_productRepository = new ProductRepository(DataHelper,
                                                                                                                        Product.COLLECTIONNAME));

        public OrderRepository OrderRepository => _orderRepository ?? (_orderRepository = new OrderRepository(DataHelper,
                                                                                                              Order.COLLECTIONNAME));

        public ShipmentRepository ShipmentRepository => _shipmentRepository ?? (_shipmentRepository = new ShipmentRepository(DataHelper,
                                                                                                              Shipment.COLLECTIONNAME));

        public CostTypeRepository CostTypeRepository => _costTypeRepository ?? (_costTypeRepository = new CostTypeRepository(DataHelper,
                                                                                                                             CostType.COLLECTIONNAME));

        public CostRepository CostRepository => _costRepository ?? (_costRepository = new CostRepository(DataHelper,
                                                                                                         Cost.COLLECTIONNAME));

        public PackageRepository PackageRepository => _packageRepository ?? (_packageRepository = new PackageRepository(DataHelper,
                                                                                                                        Package.COLLECTIONNAME));

        public CompanyRepository CompanyRepository => _companyRepository ?? (_companyRepository = new CompanyRepository(DataHelper,
                                                                                                                        Company.COLLECTIONNAME));
    }
}