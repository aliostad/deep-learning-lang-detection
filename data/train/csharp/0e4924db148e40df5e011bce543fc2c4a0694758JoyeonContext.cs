using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using Joyeon.Group.Models;

namespace Joyeon.Group.DAL
{
    public static class JoyeonContext
    {

        private static object locker = new object();
        private static IPromotionRechargeGiftRepository promotionRechargeGiftRepository;//充值赠送 by chenpan20161220
        private static IPromotionCouponRepository promotionCouponRepository;//优惠券 by chenpan 201209
        private static IPromotionCouponRecordRepository promotionCouponRecordRepository;//优惠券记录 by chenpan 201213


        private static IEmployeeRepository employeeRepository = null;
        
        private static IEmployeeDishRepository employeeDishRepository = null; // by chenpan add 20160820

        private static IFlavorRepository flavorRepository = null; // by xutao add 20161017
        private static IIngredientsRepository ingredientsRepository = null; // by xutao add 20161017

        private static IJobRepository jobRepository = null;
        private static IBranchRepository branchRepository = null;
        private static IFrameRepository frameRepository = null;
        private static IDishRepository dishRepository = null;
        private static ITableRepository tableRepository = null;
        private static IGroupRepository groupRepository = null;
        private static ICustomerRepository customerRepository = null;
        private static ICardRepository cardRepository = null;
        private static IReportRepository reportRepository = null;
        private static IPermissionRepository permissionRepository = null;
        private static ICookbookRepository cookbookRepository = null;
        private static ICookbookCategoryRepository cookbookcategoryRepository = null;
        private static IBusinessRepository businessRepository = null;
        private static IVersionControlRepository versionControlRepository = null;
        private static IDepartmentRepository departmentRepository = null;
        private static IBookRepository bookRepository = null;
        private static IPosterRepository posterRepostory = null;
        private static IMPosterRepository mposterRepostory = null;
        private static ISurveyRepository surveyRepository = null;
        private static IMessageRepository messageRepository = null;

        private static IVendorRepository vendorRepository = null;
        private static IVendorCategoryRepository vendorCategoryRepository = null;
        private static IWarehouseRepository warehouseRepository = null;
        private static ITableZoneRepository tableZoneRepository = null;

        /// <summary>
        /// 外卖
        /// </summary>
        private static ITakeOutRepository takeOutRepository = null;

        private static IPromotionRepository promotionRepository = null;

        /// <summary>
        /// 口味 2013-11-22 刘新奇 添加
        /// </summary>
        private static ITasteRepository tasteRepository = null;

        /// <summary>
        /// 微信配置  2014-5-27 16:56:27  孙凯 添加
        /// </summary>
        private static IWeixinConfigRepository weixinConfigRepository = null;

        /// <summary>
        /// 做法 2013-11-22 刘新奇 添加
        /// </summary>
        private static IPracticeRepository practiceRepository = null;

        //private static ITicketRepository ticketRepository = null;
        //private static ITicketHeaderRepository ticketHeaderRepository = null;
        //private static ITicketLineRepository ticketLineRepository = null;

        #region 采购订单
        private static IPurchaseOrderRepository purchaseOrderRepository = null;
        private static IPurchaseOrderHeaderRepository purchaseOrderHeaderRepository = null;
        private static IPurchaseOrderLineRepository purchaseOrderLineRepository = null;
        #endregion

        #region 申请
        private static IPurchaseRequisitionRepository purchaseRequisitionRepository = null;
        private static IPurchaseRequisitionHeaderRepository purchaseRequisitionHeaderRepository = null;
        private static IPurchaseRequisitionLineRepository purchaseRequisitionLineRepository = null;
        #endregion

        #region 出入库单据
        private static IInventoryTicketRepository inventoryTicketRepository = null;
        private static IInventoryTicketHeaderRepository inventoryTicketHeaderRepository = null;
        private static IInventoryTicketLineRepository inventoryTicketLineRepository = null;
        #endregion

        #region 交易记录
        private static IInventoryTransactionRepository inventoryTransactionRepository = null;
        #endregion

        #region 库存数量
        private static IBranchInventoryRepository branchInventoryRepository = null;
        #endregion

        #region 盘点
        private static ICountingRepository countingRepository = null;
        private static ICountingHeaderRepository countingHeaderRepository = null;
        private static ICountingLineRepository countingLineRepository = null;
        #endregion

        #region 日结
        private static IDailyProcessRepository dailyProcessRepository = null;
        #endregion

        #region 月结
        private static IMonthlyProcessRepository monthlyProcessRepository = null;
        #endregion

        #region 结算单
        private static ISettlementRepository settlementRepository = null;
        private static ISettlementHeaderRepository settlementHeaderRepository = null;
        private static ISettlementLineRepository settlementLineRepository = null;
        #endregion

        //private static ITicketViewRepository ticketViewRepository = null;
        private static ITicketTypeRepository ticketTypeRepository = null;

        //private static ILoggerRepository loggerRepository = null;

        private static IDiscountRepository discountRepository = null;
        private static ICooperationRepository cooperationRepository = null;
        private static IFreeRepository freeRepository = null;
        private static IEvaluateRepository evaluateRepository = null;
        private static IShortCardRepository shortCardRepository = null;

        private static IBusinessHoursRepository businessHoursRepository = null;

        private static IPaymentTypeRepository paymentTypeRepository = null;
        private static IPaymentOrderRepository paymentOrderRepository = null;
        private static ICustomPrintBillRepository customPrintBillRepository;

        private static IMessageTemplateRepository messageTemplateRepository = null;
        private static IRealTimeRepository realTimeRepository = null;
        private static IMBillRepository mbillRepository = null;
        private static IQueueRepository queueRepository = null;
        private static IQueueNumberRepository queueNumberRepository = null;
        private static IBookTableRepository bookTableRepository = null;
        private static ITableCategoryRepository tableCategoryRepository = null;
        private static ISettingRepository settingRepository = null;

        private static IRecipeRepository recipeRepository = null;

        private static IPremiumStratetyRepository premiumStratetyRepository;
        private static IDistributionRepository distributionRepository = null;
        private static IMaterialRepository materialRepository = null;
        private static IMaterialCategoryRepository materialCategoryRepository = null;
        private static IBranchDistributionRepository branchDistributionRepository = null;
        private static IAutoSaleSetting autoSaleSetting = null;
        private static ISerialNumberRepository serialNumberRepository = null;

        //private static IGroupRepository groupRepository = null;
        private static IAdminRepository adminRepository = null;

        private static IProvinceRepository provinceRepository = null;
        private static ICityRepository cityRepository = null;
        private static INoticeRepository noticeRepostory = null;
        private static IInvitationRepository invitationRepository = null;

        private static IRegionRepository regionRepository = null;

        private static IBaseDdlRepository baseDdlRepository  = null;

        public static IPromotionRechargeGiftRepository PromotionRechargeGiftRepository // 充值赠送 by chenpan add 20161220
        {
            get { return promotionRechargeGiftRepository; }
        }
        public static IPromotionCouponRepository PromotionCouponRepository // 优惠券 by chenpan add 20161209
        {
            get { return promotionCouponRepository; }
        }
        public static IPromotionCouponRecordRepository PromotionCouponRecordRepository // 优惠券 by chenpan add 20161209
        {
            get { return promotionCouponRecordRepository;}
        }





        public static IFlavorRepository FlavorRepository  // by xutao add 20161017
        {
            get { return flavorRepository; }
        }
        public static IIngredientsRepository IngredientsRepository // by xutao add 20161017
        {
            get { return ingredientsRepository; }
        }


        /// <summary>
        /// 县/区
        /// </summary>
        public static IRegionRepository RegionRepository
        {
            get { return regionRepository; }
        }

        private static IMallRepository mallRepository = null;
        /// <summary>
        /// 商圈
        /// </summary>
        public static IMallRepository MallRepository
        {
            get { return mallRepository; }
        }

        private static IWeiXinAccountRepository weiXinAccountRepository = null;
        /// <summary>
        /// 微信管理
        /// </summary>
        public static IWeiXinAccountRepository WeiXinAccountRepository
        {
            get { return weiXinAccountRepository; }
        }

        private static IPaymentAccountRepository paymentAccountRepository = null;
        /// <summary>
        /// 移动支付账户管理
        /// </summary>
        public static IPaymentAccountRepository PaymentAccountRepository
        {
            get { return paymentAccountRepository; }
        }

        private static IMPaymentRepository mpaymentRepository = null;
        /// <summary>
        /// 移动支付-支付订单
        /// </summary>
        public static IMPaymentRepository MPaymentRepository
        {
            get { return mpaymentRepository; }
        }

        /*
        private static IBlockRepository blockRepository = null;
        private static IBlockBranchRepository blockBranchRepository = null;
        private static IBlockDatabaseRepository blockDatabaseRepository = null;
        */

        /// <summary>
        ///  微信配置数据访问 2014-5-27 16:59:57 孙凯 添加
        /// </summary>
        public static IWeixinConfigRepository WeixinConfigRepository
        {
            get { return weixinConfigRepository; }
        }

        /// <summary>
        /// 做法数据访问类 2013-11-22 刘新奇 添加
        /// </summary>
        public static IPracticeRepository PracticeRepository
        {
            get { return practiceRepository; }
        }
        /// <summary>
        /// 口味数据访问类 2013-11-22 刘新奇 添加
        /// </summary>
        public static ITasteRepository TasteRepository
        {
            get { return tasteRepository; }
        }

        public static INoticeRepository NoticeRepository
        {
            get { return noticeRepostory; }
        }
        public static IInvitationRepository InvitationRepository
        {
            get { return invitationRepository; }
        }
        public static IAdminRepository AdminRepository
        {
            get { return adminRepository; }
        }
        //public static IGroupRepository GroupRepository
        //{
        //    get { return groupRepository; }
        //}
        public static IProvinceRepository ProvinceRepository
        {
            get { return provinceRepository; }
        }

        public static ICityRepository CityRepository
        {
            get { return cityRepository; }
        }
        public static ITableCategoryRepository TableCategoryRepository
        {
            get { return tableCategoryRepository; }
        }

        public static ISerialNumberRepository SerialNumberRepository
        {
            get { return serialNumberRepository; }
        }

        public static IBranchDistributionRepository BranchDistributionRepository
        {
            get { return branchDistributionRepository; }
        }

        public static IVendorCategoryRepository VendorCategoryRepository
        {
            get { return vendorCategoryRepository; }
        }

        public static IMaterialRepository MaterialRepository
        {
            get { return materialRepository; }
        }

        public static IMaterialCategoryRepository MaterialCategoryRepository
        {
            get { return materialCategoryRepository; }
        }

        public static IDistributionRepository DistributionRepository
        {
            get { return distributionRepository; }
        }
        /*public static ISMSRepository SMSRepository
        {
            get { return vendorCategoryRepository; }
        }*/

        public static IBookTableRepository BookTableRepository
        {
            get
            {
                return bookTableRepository;
            }
        }

        public static IQueueRepository QueueRepository
        {
            get
            {
                return queueRepository;
            }
        }

        public static IMBillRepository MBillRepository
        {
            get
            {
                return mbillRepository;
            }
        }

        public static IRealTimeRepository RealTimeRepository
        {
            get
            {
                return realTimeRepository;
            }
        }

        public static IMessageRepository MessageRepository
        {
            get
            {
                return messageRepository;
            }
        }

        public static ISurveyRepository SurveyRepository
        {
            get
            {
                return surveyRepository;
            }
        }

        public static ICookbookRepository CookbookRepository
        {
            get
            {
                return cookbookRepository;
            }
        }
        public static ICookbookCategoryRepository CookbookCategoryRepository
        {
            get
            {
                return cookbookcategoryRepository;
            }
        }

        public static ICardRepository CardRepository
        {
            get
            {
                return cardRepository;
            }
        }

        public static ICustomerRepository CustomerRepository
        {
            get
            {
                return customerRepository;
            }
        }

        public static IGroupRepository GroupRepository
        {
            get
            {
                return groupRepository;
            }
        }

        public static ITableRepository TableRepository
        {
            get
            {
                return tableRepository;
            }
        }

        public static ITableZoneRepository TableZoneRepository
        {
            get
            {
                return tableZoneRepository;
            }
        }

        public static IFrameRepository FrameRepository
        {
            get
            {
                return frameRepository;
            }
        }

        public static IEmployeeRepository EmployeeRepository
        {
            get
            {
                return employeeRepository;
            }
        }


        public static IEmployeeDishRepository EmployeeDishRepository
        {
            get
            {
                return employeeDishRepository;
            }
        }

        public static IJobRepository JobRepository
        {
            get
            {
                return jobRepository;
            }
        }

        public static IBranchRepository BranchRepository
        {
            get
            {
                return branchRepository;
            }
        }

        public static IDishRepository DishRepository
        {
            get
            {
                return dishRepository;
            }
        }

        public static IReportRepository ReportRepository
        {
            get
            {
                return reportRepository;
            }
        }

        /// <summary>
        /// 系统权限
        /// </summary>
        public static IPermissionRepository PermissionRepository
        {
            get
            {
                return permissionRepository;
            }
        }
        public static IPromotionRepository PromotionRepository
        {
            get
            {
                return promotionRepository;
            }
        }
        /// <summary>
        /// 营业数据
        /// </summary>
        public static IBusinessRepository BusinessRepository
        {
            get
            {
                return businessRepository;
            }
        }

        /// <summary>
        /// 同步信息
        /// </summary>
        public static IVersionControlRepository VersionControlRepository
        {
            get
            {
                return versionControlRepository;
            }
        }

        /// <summary>
        /// 部门
        /// </summary>
        public static IDepartmentRepository DepartmentRepository
        {
            get
            {
                return departmentRepository;
            }
        }
        ///// <summary>
        ///// 集团用户返回0
        ///// </summary>
        ///// <returns></returns>
        //public static int GetCurrentUserBranchId()
        //{
        //    Branch branch = GetCurrentUserBranch();
        //    return branch == null ? 0 : branch.Id;
        //}
        ///// <summary>
        ///// 得到登陆人所属部门id
        ///// </summary>
        ///// <returns></returns>
        //public static Branch GetCurrentUserBranch()
        //{
        //    Group.User user = this.CurrentUser;
        //    int userId = user.Id;
        //    Branch b = new Branch() { Id = 0, Name = "集团" };
        //    Employee emp = EmployeeRepository.GetById(userId);
        //    return (user.IsAdmin == true) ? b : emp == null ? new Branch() : emp.Job.Branch;
        //}
        /// <summary>
        /// 预订
        /// </summary>
        public static IBookRepository BookRepository
        {
            get
            {
                return bookRepository;
            }
        }

        /// <summary>
        /// 营销
        /// </summary>
        public static IPosterRepository PosterRepository
        {
            get
            {
                return posterRepostory;
            }
        }
        /// <summary>
        /// 手机广告
        /// </summary>
        public static IMPosterRepository MPosterRepository
        {
            get
            {
                return mposterRepostory;
            }
        }
        /// <summary>
        /// 外卖
        /// </summary>
        public static ITakeOutRepository TakeOutRepository
        {
            get
            {
                return takeOutRepository;
            }
        }

        /// <summary>
        /// 外卖明细（存放bill相关表中）2013/11/5
        /// </summary>
        //public static ITakeOutDishRepository TakeOutDishRepository
        //{
        //    get
        //    {
        //        return takeOutDishRepository;
        //    }
        //}
        //public static int GetCurrentUserId()
        //{
        //    try
        //    {
        //        HttpCookie emp = HttpContext.Current.Request.Cookies["employee"];
        //        if (emp != null)
        //        {
        //            return int.Parse(emp["Id"]);
        //        }
        //    }
        //    catch (Exception)
        //    {
        //    }
        //    return 0;

        //}

        //public static string GetCurrentUserLoginName()
        //{
        //    try
        //    {
        //        HttpCookie emp = HttpContext.Current.Request.Cookies["employee"];
        //        if (emp != null)
        //        {
        //            return HttpUtility.UrlDecode(emp["Name"]);
        //        }
        //    }
        //    catch (Exception)
        //    {
        //    }
        //    return string.Empty;

        //}

        //public static string GetCurrentUserSiteName()
        //{
        //    try
        //    {
        //        HttpCookie emp = HttpContext.Current.Request.Cookies["employee"];
        //        if (emp != null)
        //        {
        //            return HttpUtility.UrlDecode(emp["SiteName"]);
        //        }
        //    }
        //    catch (Exception)
        //    {
        //    }
        //    return string.Empty;
        //}

        private static IAfterSaleServiceRepository afterSaleServiceRepository = null;

        public static IAfterSaleServiceRepository AfterSaleServiceRepository
        {
            get { return afterSaleServiceRepository; }
        }
        public static IBaseDdlRepository BaseDdlRepository
        {
            get { return baseDdlRepository; }
        }
        public static void FillBaseUpdateInfo(Base b)
        {
            b.ModifyTime = DateTime.Now;
            b.ModifyUser = App.GetCurrentUser().EmployeeId;
        }

        public static void FillBaseInsertInfo(Base b)
        {
            var user = App.GetCurrentUser();
            b.CreateTime = DateTime.Now;
            b.CreateUser = user.EmployeeId;
            b.ModifyTime = DateTime.Now;
            b.ModifyUser = user.EmployeeId;
        }

        public static int SortNumberStep { get; private set; }

        public static IVendorRepository VendorRepository
        {
            get
            {
                return vendorRepository;
            }
        }

        public static IWarehouseRepository WarehouseRepository
        {
            get
            {
                return warehouseRepository;
            }
        }

        #region ticket

        //public static ITicketRepository TicketRepository
        //{
        //    get { return ticketRepository; }
        //}

        //public static ITicketHeaderRepository TicketHeaderRepository
        //{
        //    get { return ticketHeaderRepository; }
        //}

        //public static ITicketLineRepository TicketLineRepository
        //{
        //    get { return ticketLineRepository; }
        //}
        //public static ITicketViewRepository TicketViewRepository
        //       {
        //           get
        //           {
        //               return ticketViewRepository;
        //           }
        //       }

        //       public static ITicketTypeRepository TicketTypeRepository
        //       {
        //           get
        //           {
        //               return ticketTypeRepository;
        //           }
        //       }
        #endregion

        #region 采购订单
        public static IPurchaseOrderRepository PurchaseOrderRepository
        {
            get
            {
                return purchaseOrderRepository;
            }
        }

        public static IPurchaseOrderHeaderRepository PurchaseOrderHeaderRepository
        {
            get
            {
                return purchaseOrderHeaderRepository;
            }
        }

        public static IPurchaseOrderLineRepository PurchaseOrderLineRepository
        {
            get
            {
                return purchaseOrderLineRepository;
            }
        }

        #endregion

        #region 申请
        public static IPurchaseRequisitionRepository PurchaseRequisitionRepository
        {
            get
            {
                return purchaseRequisitionRepository;
            }
        }

        public static IPurchaseRequisitionHeaderRepository PurchaseRequisitionHeaderRepository
        {
            get
            {
                return purchaseRequisitionHeaderRepository;
            }
        }

        public static IPurchaseRequisitionLineRepository PurchaseRequisitionLineRepository
        {
            get
            {
                return purchaseRequisitionLineRepository;
            }
        }

        #endregion

        #region 出入库单据
        public static IInventoryTicketRepository InventoryTicketRepository
        {
            get
            {
                return inventoryTicketRepository;
            }
        }

        public static IInventoryTicketHeaderRepository InventoryTicketHeaderRepository
        {
            get
            {
                return inventoryTicketHeaderRepository;
            }
        }

        public static IInventoryTicketLineRepository InventoryTicketLineRepository
        {
            get
            {
                return inventoryTicketLineRepository;
            }
        }

        #endregion

        #region 交易记录
        public static IInventoryTransactionRepository InventoryTransactionRepository
        {
            get
            {
                return inventoryTransactionRepository;
            }
        }

        #endregion

        #region 库存数量
        public static IBranchInventoryRepository BranchInventoryRepository
        {
            get
            {
                return branchInventoryRepository;
            }
        }

        //public static ILoggerRepository LoggerRepository
        //{
        //    get
        //    {
        //        return loggerRepository;
        //    }
        //}

        public static IDiscountRepository DiscountRepository
        {
            get { return discountRepository; }
        }

        public static ICooperationRepository CooperationRepository
        {
            get { return cooperationRepository; }
        }

        public static IFreeRepository FreeRepository
        {
            get { return freeRepository; }
        }

        public static IEvaluateRepository EvaluateRepository
        {
            get { return evaluateRepository; }
        }

        public static IShortCardRepository ShortCardRepository
        {
            get { return shortCardRepository; }
        }

        public static IBusinessHoursRepository BusinessHoursRepository
        {
            get { return businessHoursRepository; }
        }

        public static IPaymentTypeRepository PaymentTypeRepository
        {
            get
            {
                return paymentTypeRepository;
            }
        }

        public static IPaymentOrderRepository PaymentOrderRepository
        {
            get
            {
                return paymentOrderRepository;
            }
        }
        public static ICustomPrintBillRepository CustomPrintBillRepository
        {
            get
            {
                return customPrintBillRepository;
            }
        }

        public static ISettingRepository SettingRepository
        {
            get
            {
                return settingRepository;
            }
        }

        public static IMessageTemplateRepository MessageTemplateRepository
        {
            get
            {
                return messageTemplateRepository;
            }
        }
        public static IQueueNumberRepository QueueNumberRepository
        {
            get
            {
                return queueNumberRepository;
            }
        }

        public static IRecipeRepository RecipeRepository
        { get { return recipeRepository; } }

        public static IPremiumStratetyRepository PremiumStratetyRepository
        {
            get
            {
                return premiumStratetyRepository;
            }
        }

        public static IAutoSaleSetting AutoSaleSetting
        {
            get { return JoyeonContext.autoSaleSetting; }
        }

        #endregion

        #region 盘点
        public static ICountingRepository CountingRepository
        {
            get
            {
                return countingRepository;
            }
        }

        public static ICountingHeaderRepository CountingHeaderRepository
        {
            get
            {
                return countingHeaderRepository;
            }
        }

        public static ICountingLineRepository CountingLineRepository
        {
            get
            {
                return countingLineRepository;
            }
        }

        #endregion

        #region 日结
        public static IDailyProcessRepository DailyProcessRepository
        {
            get
            {
                return dailyProcessRepository;
            }
        }
        #endregion

        #region 月结
        public static IMonthlyProcessRepository MonthlyProcessRepository
        {
            get { return monthlyProcessRepository; }
        }
        #endregion

        #region 结算单
        public static ISettlementRepository SettlementRepository
        {
            get
            {
                return settlementRepository;
            }
        }

        public static ISettlementHeaderRepository SettlementHeaderRepository
        {
            get
            {
                return settlementHeaderRepository;
            }
        }

        public static ISettlementLineRepository SettlementLineRepository
        {
            get
            {
                return settlementLineRepository;
            }
        }

        /// <summary>
        /// 外卖明细（存放bill相关表中）2013/11/5
        /// </summary>
        //public static ITakeOutDishRepository TakeOutDishRepository
        //{
        //    get
        //    {
        //        return takeOutDishRepository;
        //    }
        //}
        //public static int GetCurrentUserId()
        //{
        //    try
        //    {
        //        HttpCookie emp = HttpContext.Current.Request.Cookies["employee"];
        //        if (emp != null)
        //        {
        //            return int.Parse(emp["Id"]);
        //        }
        //    }
        //    catch (Exception)
        //    {
        //    }
        //    return 0;
        //}
        //public static string GetCurrentUserLoginName()
        //{
        //    try
        //    {
        //        HttpCookie emp = HttpContext.Current.Request.Cookies["employee"];
        //        if (emp != null)
        //        {
        //            return HttpUtility.UrlDecode(emp["Name"]);
        //        }
        //    }
        //    catch (Exception)
        //    {
        //    }
        //    return string.Empty;
        //}
        //public static string GetCurrentUserSiteName()
        //{
        //    try
        //    {
        //        HttpCookie emp = HttpContext.Current.Request.Cookies["employee"];
        //        if (emp != null)
        //        {
        //            return HttpUtility.UrlDecode(emp["SiteName"]);
        //        }
        //    }
        //    catch (Exception)
        //    {
        //    }
        //    return string.Empty;
        //}

        #endregion

        //PremiumStratetyRepository
        /*
        public static IBlockRepository BlockRepository
        {
            get { return blockRepository; }
        }
        public static IBlockBranchRepository BlockBranchRepository
        {
            get { return blockBranchRepository; }
        }
        public static IBlockDatabaseRepository BlockDatabaseRepository
        {
            get { return blockDatabaseRepository; }
        }*/

        static JoyeonContext()
        {
            var sInstance = DataHelper.SpringApplicationContext.Instance;
            weixinConfigRepository = sInstance.GetObject<IWeixinConfigRepository>("WeixinConfigRepository");
            messageRepository = sInstance.GetObject<IMessageRepository>("MessageRepository");
            surveyRepository = sInstance.GetObject<ISurveyRepository>("SurveyRepository");
            cookbookRepository = sInstance.GetObject<ICookbookRepository>("CookbookRepository");
            cookbookcategoryRepository = sInstance.GetObject<ICookbookCategoryRepository>("CookbookCategoryRepository");
            cardRepository = sInstance.GetObject<ICardRepository>("CardRepository");
            customerRepository = sInstance.GetObject<ICustomerRepository>("CustomerRepository");
            groupRepository = sInstance.GetObject<IGroupRepository>("GroupRepository");
            tableRepository = sInstance.GetObject<ITableRepository>("TableRepository");
            tableCategoryRepository = sInstance.GetObject<ITableCategoryRepository>("TableCategoryRepository");
            frameRepository = sInstance.GetObject<IFrameRepository>("FrameRepository");
            employeeRepository = sInstance.GetObject<IEmployeeRepository>("EmployeeRepository");
            //厨师菜品设置 by chenpan  20160823
            employeeDishRepository = sInstance.GetObject<IEmployeeDishRepository>("EmployeeDishRepository");
            jobRepository = sInstance.GetObject<IJobRepository>("JobRepository");
            branchRepository = sInstance.GetObject<IBranchRepository>("BranchRepository");
            dishRepository = sInstance.GetObject<IDishRepository>("DishRepository");
            reportRepository = new ReportRepository();
            permissionRepository = sInstance.GetObject<IPermissionRepository>("PermissionRepository");
            businessRepository = sInstance.GetObject<IBusinessRepository>("BusinessRepository");
            versionControlRepository = sInstance.GetObject<IVersionControlRepository>("VersionControlRepository");
            departmentRepository = sInstance.GetObject<IDepartmentRepository>("DepartmentRepository");
            bookRepository = sInstance.GetObject<IBookRepository>("BookRepository");
            posterRepostory = sInstance.GetObject<IPosterRepository>("PosterRepository");
            mposterRepostory = sInstance.GetObject<IMPosterRepository>("MPosterRepository");
            promotionRepository = sInstance.GetObject<IPromotionRepository>("PromotionRepository");
            tasteRepository = sInstance.GetObject<ITasteRepository>("TasteRepository");
            practiceRepository = sInstance.GetObject<IPracticeRepository>("PracticeRepository");
            SortNumberStep = AppSettings.Instance.SortNumberStep;

            vendorRepository = sInstance.GetObject<IVendorRepository>("VendorRepository");

            vendorCategoryRepository = sInstance.GetObject<IVendorCategoryRepository>("VendorCategoryRepository");

            warehouseRepository = sInstance.GetObject<IWarehouseRepository>("WarehouseRepository");

            #region ticket

            //           ticketRepository = sInstance.GetObject<ITicketRepository>("TicketRepository");
            //           ticketHeaderRepository = sInstance.GetObject<TicketHeaderRepository>("TicketHeaderRepository");
            //           ticketLineRepository = sInstance.GetObject<TicketLineRepository>("TicketLineRepository");
            //ticketViewRepository = sInstance.GetObject<ITicketViewRepository>("TicketViewRepository");

            #endregion

            #region 采购订单
            purchaseOrderRepository = sInstance.GetObject<IPurchaseOrderRepository>("PurchaseOrderRepository");
            purchaseOrderHeaderRepository = sInstance.GetObject<IPurchaseOrderHeaderRepository>("PurchaseOrderHeaderRepository");
            purchaseOrderLineRepository = sInstance.GetObject<IPurchaseOrderLineRepository>("PurchaseOrderLineRepository");
            #endregion

            #region 申请
            purchaseRequisitionRepository = sInstance.GetObject<IPurchaseRequisitionRepository>("PurchaseRequisitionRepository");
            purchaseRequisitionHeaderRepository = sInstance.GetObject<IPurchaseRequisitionHeaderRepository>("PurchaseRequisitionHeaderRepository");
            purchaseRequisitionLineRepository = sInstance.GetObject<IPurchaseRequisitionLineRepository>("PurchaseRequisitionLineRepository");
            #endregion

            #region 出入库单据
            inventoryTicketRepository = sInstance.GetObject<IInventoryTicketRepository>("InventoryTicketRepository");
            inventoryTicketHeaderRepository = sInstance.GetObject<IInventoryTicketHeaderRepository>("InventoryTicketHeaderRepository");
            inventoryTicketLineRepository = sInstance.GetObject<IInventoryTicketLineRepository>("InventoryTicketLineRepository");
            #endregion

            #region 交易记录
            inventoryTransactionRepository = sInstance.GetObject<IInventoryTransactionRepository>("InventoryTransactionRepository");
            #endregion

            #region 库存数量
            branchInventoryRepository = sInstance.GetObject<IBranchInventoryRepository>("BranchInventoryRepository");
            #endregion

            #region 盘点
            countingRepository = sInstance.GetObject<ICountingRepository>("CountingRepository");
            countingHeaderRepository = sInstance.GetObject<ICountingHeaderRepository>("CountingHeaderRepository");
            countingLineRepository = sInstance.GetObject<ICountingLineRepository>("CountingLineRepository");
            #endregion

            #region 日结
            dailyProcessRepository = sInstance.GetObject<IDailyProcessRepository>("DailyProcessRepository");
            #endregion

            #region 月结
            monthlyProcessRepository = sInstance.GetObject<IMonthlyProcessRepository>("MonthlyProcessRepository");
            #endregion

            #region 结算单
            settlementRepository = sInstance.GetObject<ISettlementRepository>("SettlementRepository");
            settlementHeaderRepository = sInstance.GetObject<ISettlementHeaderRepository>("SettlementHeaderRepository");
            settlementLineRepository = sInstance.GetObject<ISettlementLineRepository>("SettlementLineRepository");
            #endregion

            ticketTypeRepository = sInstance.GetObject<ITicketTypeRepository>("TicketTypeRepository");
            //loggerRepository = sInstance.GetObject<ILoggerRepository>("LoggerRepository");
            discountRepository = sInstance.GetObject<IDiscountRepository>("DiscountRepository");
            cooperationRepository = sInstance.GetObject<ICooperationRepository>("CooperationRepository");
            freeRepository = sInstance.GetObject<IFreeRepository>("FreeRepository");
            evaluateRepository = sInstance.GetObject<IEvaluateRepository>("EvaluateRepository");
            shortCardRepository = sInstance.GetObject<IShortCardRepository>("ShortCardRepository");
            businessHoursRepository = sInstance.GetObject<IBusinessHoursRepository>("BusinessHoursRepository");
            paymentTypeRepository = sInstance.GetObject<IPaymentTypeRepository>("PaymentTypeRepository");
            paymentOrderRepository = sInstance.GetObject<IPaymentOrderRepository>("PaymentOrderRepository");
            settingRepository = sInstance.GetObject<ISettingRepository>("SettingRepository");
            messageTemplateRepository = sInstance.GetObject<IMessageTemplateRepository>("MessageTemplateRepository");
            customPrintBillRepository = sInstance.GetObject<ICustomPrintBillRepository>("CustomPrintBillRepository");
            realTimeRepository = sInstance.GetObject<IRealTimeRepository>("RealTimeRepository");
            mbillRepository = sInstance.GetObject<IMBillRepository>("MBillRepository");
            queueRepository = sInstance.GetObject<IQueueRepository>("QueueRepository");

            materialRepository = sInstance.GetObject<IMaterialRepository>("MaterialRepository");
            materialCategoryRepository = sInstance.GetObject<IMaterialCategoryRepository>("MaterialCategoryRepository");
            queueNumberRepository = sInstance.GetObject<IQueueNumberRepository>("QueueNumberRepository");
            recipeRepository = sInstance.GetObject<IRecipeRepository>("RecipeRepository");
            bookTableRepository = sInstance.GetObject<IBookTableRepository>("BookTableRepository");

            premiumStratetyRepository = sInstance.GetObject<IPremiumStratetyRepository>("PremiumStratetyRepository");
            distributionRepository = sInstance.GetObject<IDistributionRepository>("DistributionRepository");

            serialNumberRepository = sInstance.GetObject<ISerialNumberRepository>("SerialNumberRepository");

            branchDistributionRepository =
                sInstance.GetObject<IBranchDistributionRepository>("BranchDistributionRepository");

            autoSaleSetting = sInstance.GetObject<IAutoSaleSetting>("AutoSaleSettingRepository");

            tableZoneRepository = sInstance.GetObject<ITableZoneRepository>("TableZoneRepository");
            //groupRepository = sInstance.GetObject<IGroupRepository>("GroupRepository");
            adminRepository = sInstance.GetObject<IAdminRepository>("AdminRepository");
            noticeRepostory = sInstance.GetObject<INoticeRepository>("NoticeRepository");
            invitationRepository = sInstance.GetObject<IInvitationRepository>("InvitationRepository");

            //外卖
            takeOutRepository = sInstance.GetObject<ITakeOutRepository>("TakeOutRepository");
            //售后
            afterSaleServiceRepository =
                sInstance.GetObject<IAfterSaleServiceRepository>(
                    "AfterSaleServiceRepository");

            provinceRepository = sInstance.GetObject<IProvinceRepository>("ProvinceRepository");
            cityRepository = sInstance.GetObject<ICityRepository>("CityRepository");
            //区/县
            regionRepository = sInstance.GetObject<IRegionRepository>("RegionRepository");
            //商圈
            mallRepository = sInstance.GetObject<IMallRepository>("MallRepository");

            //微信管理
            weiXinAccountRepository = sInstance.GetObject<IWeiXinAccountRepository>("WeiXinAccountRepository");
            //移动支付账户管理
            paymentAccountRepository = sInstance.GetObject<IPaymentAccountRepository>("PaymentAccountRepository");
            //移动支付-支付订单
            mpaymentRepository = sInstance.GetObject<IMPaymentRepository>("MPaymentRepository");

            baseDdlRepository = sInstance.GetObject<IBaseDdlRepository>("BaseDdlRepository");
            /*blockRepository = sInstance.GetObject<IBlockRepository>("BlockRepository");
            blockBranchRepository = sInstance.GetObject<IBlockBranchRepository>("BlockBranchRepository");
            blockDatabaseRepository = sInstance.GetObject<IBlockDatabaseRepository>("BlockDatabaseRepository");
             * */

            //食材 by xutao20161017
            ingredientsRepository = sInstance.GetObject<IIngredientsRepository>("IngredientsRepository");
            //味型 by xutao20161017

            flavorRepository = sInstance.GetObject<IFlavorRepository>("FlavorRepository");

            promotionCouponRepository = sInstance.GetObject<IPromotionCouponRepository>("PromotionCouponRepository");// by chenpan 20161213
            promotionCouponRecordRepository = sInstance.GetObject<IPromotionCouponRecordRepository>("PromotionCouponRecordRepository");// by chenpan 20161213
            promotionRechargeGiftRepository = sInstance.GetObject<IPromotionRechargeGiftRepository>("PromotionRechargeGiftRepository");// by chenpan 20161220

        }
    }
}
