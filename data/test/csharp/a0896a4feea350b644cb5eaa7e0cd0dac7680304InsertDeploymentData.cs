using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Distributr.Core.CommandHandler.DocumentCommandHandlers;
using Distributr.Core.CommandHandler.DocumentCommandHandlers.Losses;
using Distributr.Core.CommandHandler.DocumentCommandHandlers.Orders;
using Distributr.Core.Domain.Master.CostCentreEntities;
using Distributr.Core.Domain.Master.ProductEntities;
using Distributr.Core.Domain.Master.SettingsEntities;
using Distributr.Core.Domain.Master.UserEntities;
using Distributr.Core.Factory.Documents;
using Distributr.Core.Factory.Master;
using Distributr.Core.Repository.Financials;
using Distributr.Core.Repository.InventoryRepository;
using Distributr.Core.Repository.Master;
using Distributr.Core.Repository.Master.AssetRepositories;
using Distributr.Core.Repository.Master.BankRepositories;
using Distributr.Core.Repository.Master.ChannelPackagings;
using Distributr.Core.Repository.Master.CompetitorManagement;
using Distributr.Core.Repository.Master.CoolerTypeRepositories;
using Distributr.Core.Repository.Master.CostCentreRepositories;
using Distributr.Core.Repository.Master.DistributorTargetRepositories;
using Distributr.Core.Repository.Master.ProductRepositories;
using Distributr.Core.Repository.Master.ReOrderLevelRepository;
using Distributr.Core.Repository.Master.SettingsRepositories;
using Distributr.Core.Repository.Master.SuppliersRepositories;
using Distributr.Core.Repository.Master.UserRepositories;
using Distributr.Core.Repository.Transactional.DocumentRepositories;

namespace Distributr.DatabaseSetup
{
    class InsertDeploymentData: InsertTestDataBase, IInsertTestData
    {
       
        //protected IBankRepository _bankRepository;
        //protected IBankBranchRepository _bankBranchRepository;
        #region Constructors
        public InsertDeploymentData(IOutletPriorityRepository outletPriorityRepository,
         IOutletVisitDayRepository outletVisitDayRepository, IAssetStatusRepository assetStatusRepository,
        IAssetCategoryRepository assetCategoryRepository, IUserGroupRepository userGroupRepository, IUserGroupRolesRepository userGroupRolesRepository, ISalesmanRouteRepository salesmanRouteRepository,ISalesmanSupplierRepository salesmanSupplierRepository, IProductTypeRepository productTypeRepository, IProductBrandRepository productBrandRepository, IProductFlavourRepository productFlavourRepository, IProductPackagingRepository productPackagingRepository, IProductPackagingTypeRepository productPackagingTypeRepository, IProductRepository productRepository, IRegionRepository regionRepository, ICostCentreRepository costCentreRepository, ICostCentreFactory costCentreFactory, IProductPricingRepository pricingRepository,
            IVATClassRepository vatClassRepository, IVATClassFactory vatClassFactory, ICountryRepository countryRepository,
            IProductPricingFactory productPricingFactory, IProductPricingTierRepository productPricingTierRepository,
            IOutletTypeRepository outletTypeRepository, IUserRepository userRepository, IOutletRepository outletRepository,
            IRouteRepository routeRepository, IRouteFactory routeFactory, ITransporterRepository transporterRepository,
            IProductFactory productFactory, IDistributorSalesmanRepository distributorSalesmanRepository,
            IProducerRepository producerRepository,  IDocumentFactory documentFactory,
            ISocioEconomicStatusRepository socioEconomicStatusRepository, IClientMasterDataTrackerRepository clientMasterDataTrackerRepository,
            IDistributorRepository distributorrepository, IOutletCategoryRepository outletCategoryRepository, 
            ITerritoryRepository territoryRepository,  
             IAreaRepository areaRepository,
            IContactRepository contactRepository, IAccountRepository accountRepository, IAccountTransactionRepository accountTransactionRepository,
            IInventoryRepository inventoryRepository, IInventoryTransactionRepository inventoryTransactionRepository,
            ICostCentreApplicationRepository costCentreApplicationRepository, IChannelPackagingRepository channelPackagingRepository,
            ICompetitorRepository competitorRepository, ICompetitorProductsRepository competitorProductRepository, IAssetRepository coolerRepository,
            IAssetTypeRepository coolerTypeRepository, IDistrictRepository districtRepository, IProvincesRepository provinceRepository,
            IReOrderLevelRepository reorderLevelRepository, ITargetPeriodRepository targetPeriodRepository, ITargetRepository targetRepository,
            IProductDiscountFactory productDiscountFactory, IProductDiscountRepository productDiscountRepository, ISaleValueDiscountFactory saleValueDiscountFactory,
            ISaleValueDiscountRepository saleValueDiscountRepository, IBankRepository bankRepository, IBankBranchRepository bankBranchRepository,
            ISupplierRepository supplierRepository, ICreatePaymentNoteCommandHandler createLossCommandHandler, IAddPaymentNoteLineItemCommandHandler addLossLineItemCommandHandler, IConfirmPaymentNoteCommandHandler confirmLossCommandHandler,
             IContactTypeRepository contactTypeRepository, IDiscountGroupRepository discountGroupRepository, IProductDiscountGroupFactory productDiscountGroupFactory,
         ICertainValueCertainProductDiscountFactory certainValueCertainProductDiscountFactory,
         ICustomerDiscountFactory customerDiscountFactory,
         IPromotionDiscountFactory promotionDiscountFactory,
         IProductDiscountGroupRepository productDiscountGroupRepository,
         IPromotionDiscountRepository promotionDiscountRepository,
         IFreeOfChargeDiscountRepository freeOfChargeDiscountRepository,
         ICertainValueCertainProductDiscountRepository certainValueCertainProductDiscountRepository, ITargetItemRepository targetItemRepository, ISettingsRepository settingsRepository
            )
        {
            _productTypeRepository = productTypeRepository;
            _productBrandRepository = productBrandRepository;
            _productFlavourRepository = productFlavourRepository;
            _productPackagingRepository = productPackagingRepository;
            _productPackagingTypeRepository = productPackagingTypeRepository;
            _productRepository = productRepository;
            _regionRepository = regionRepository;
            _costCentreRepository = costCentreRepository;
            _costCentreFactory = costCentreFactory;
            _pricingRepository = pricingRepository;
            _vatClassRepository = vatClassRepository;
            _vatClassFactory = vatClassFactory;
            _countryRepository = countryRepository;
            _productPricingFactory = productPricingFactory;
            _ProductPricingTierRepository = productPricingTierRepository;
            _outletTypeRepository = outletTypeRepository;
            _userRepository = userRepository;
            _outletRepository = outletRepository;
            _routeRepository = routeRepository;
            _routeFactory = routeFactory;
            _transporterRepository = transporterRepository;
            _productFactory = productFactory;
            _distributorSalesmanRepository = distributorSalesmanRepository;
            _producerRepository = producerRepository;
            _documentFactory = documentFactory;
            _socioEconomicStatusRepository = socioEconomicStatusRepository;
            _clientMasterDataTrackerRepository = clientMasterDataTrackerRepository;
            _distributorrepository = distributorrepository;
            _outletCategoryRepository = outletCategoryRepository;
            _territoryRepository = territoryRepository;
            _areaRepository = areaRepository;
            _contactRepository = contactRepository;
            _accountRepository = accountRepository;
            _accountTransactionRepository = accountTransactionRepository;
            _inventoryRepository = inventoryRepository;
            _inventoryTransactionRepository = inventoryTransactionRepository;
            _costCentreApplicationRepository = costCentreApplicationRepository;
            _channelPackagingRepository = channelPackagingRepository;
            _competitorRepository = competitorRepository;
            _competitorProductRepository = competitorProductRepository;
            _coolerRepository = coolerRepository;
            _coolerTypeRepository = coolerTypeRepository;
            _districtRepository = districtRepository;
            _provinceRepository = provinceRepository;
            _reorderLevelRepository = reorderLevelRepository;
            _targetPeriodRepository = targetPeriodRepository;
            _targetRepository = targetRepository;
            _productDiscountFactory = productDiscountFactory;
            _productDiscountRepository = productDiscountRepository;
            _saleValueDiscountFactory = saleValueDiscountFactory;
            _saleValueDiscountRepository = saleValueDiscountRepository;
            _salesmanRouteRepository = salesmanRouteRepository;
            _salesmanSupplierRepository = salesmanSupplierRepository;
            _userGroupRepository = userGroupRepository;
            _userGroupRolesRepository = userGroupRolesRepository;
            _bankRepository = bankRepository;
            _bankBranchRepository = bankBranchRepository;
            _supplierRepository = supplierRepository;
            _createLossCommandHandler = createLossCommandHandler;
            _addLossLineItemCommandHandler = addLossLineItemCommandHandler;
            _confirmLossCommandHandler = confirmLossCommandHandler;
           
            _contactTypeRepository = contactTypeRepository;
            _assetCategoryRepository = assetCategoryRepository;
            _assetStatusRepository = assetStatusRepository;
            _discountGroupRepository = discountGroupRepository;
            _productDiscountGroupFactory = productDiscountGroupFactory;
            _certainValueCertainProductDiscountFactory = certainValueCertainProductDiscountFactory;
            _customerDiscountFactory = customerDiscountFactory;
            _promotionDiscountFactory = promotionDiscountFactory;
            _productDiscountGroupRepository = productDiscountGroupRepository;
            _promotionDiscountRepository = promotionDiscountRepository;
            _freeOfChargeDiscountRepository = freeOfChargeDiscountRepository;
            _certainValueCertainProductDiscountRepository = certainValueCertainProductDiscountRepository;
            _outletPriorityRepository = outletPriorityRepository;
            _outletVisitDayRepository = outletVisitDayRepository;
            _targetItemRepository = targetItemRepository;
            _settingsRepository = settingsRepository;

        }


        #endregion

        public void InsertTestMasterData()
        {
            DateTime dt = DateTime.Now;

              AddProducerCC("sapDemoProducer");
         
            var prodr = _producerRepository.GetAll().FirstOrDefault();

    
            //Add User ASM
            Guid groupId = AddUserGroup("Admin");
            AddUserGroupRoles(groupId);
            Guid usrSRep1 = AddUser("sapDemoHQ", "12345678", "0750000200", "AADD129", prodr.Id, UserType.HQAdmin, groupId);
            Guid usrSRep = AddUser("sapDemoRep", "12345678", "0750000200", "AADD127", prodr.Id, UserType.SalesRep, groupId);

           

            
        }

    }
}
