using System;
using System.Data.Entity;
using DAL.Generic.Repository.Base;
using Model;

namespace DAL.Generic.UnitofWork
{
    public class UnitofWork : IGenericUnitofWork
    {
        public  DbContext Context;

        public UnitofWork()
        {
            Context = new PrivateChefContext();
        }

        public UnitofWork(DbContext context)
        {
            Context = context;
        }

        //Model
 

        private IGenericRepository<AddressType> _addressTypeRepository;
        public IGenericRepository<AddressType> AddressTypeRepository
        {
            get { return  _addressTypeRepository ?? ( _addressTypeRepository = new GenericRepository<AddressType>(Context)); }
            set {  _addressTypeRepository = value; }
        }
    

        private IGenericRepository<Client> _clientRepository;
        public IGenericRepository<Client> ClientRepository
        {
            get { return  _clientRepository ?? ( _clientRepository = new GenericRepository<Client>(Context)); }
            set {  _clientRepository = value; }
        }
    

        private IGenericRepository<ClientAddress> _clientAddressRepository;
        public IGenericRepository<ClientAddress> ClientAddressRepository
        {
            get { return  _clientAddressRepository ?? ( _clientAddressRepository = new GenericRepository<ClientAddress>(Context)); }
            set {  _clientAddressRepository = value; }
        }
    

        private IGenericRepository<ClientFeedBack> _clientFeedBackRepository;
        public IGenericRepository<ClientFeedBack> ClientFeedBackRepository
        {
            get { return  _clientFeedBackRepository ?? ( _clientFeedBackRepository = new GenericRepository<ClientFeedBack>(Context)); }
            set {  _clientFeedBackRepository = value; }
        }
    

        private IGenericRepository<ClientOrderReviewReceived> _clientOrderReviewReceivedRepository;
        public IGenericRepository<ClientOrderReviewReceived> ClientOrderReviewReceivedRepository
        {
            get { return  _clientOrderReviewReceivedRepository ?? ( _clientOrderReviewReceivedRepository = new GenericRepository<ClientOrderReviewReceived>(Context)); }
            set {  _clientOrderReviewReceivedRepository = value; }
        }
    

        private IGenericRepository<ClientOrderReviewSent> _clientOrderReviewSentRepository;
        public IGenericRepository<ClientOrderReviewSent> ClientOrderReviewSentRepository
        {
            get { return  _clientOrderReviewSentRepository ?? ( _clientOrderReviewSentRepository = new GenericRepository<ClientOrderReviewSent>(Context)); }
            set {  _clientOrderReviewSentRepository = value; }
        }
    

        private IGenericRepository<ClientOrderToReview> _clientOrderToReviewRepository;
        public IGenericRepository<ClientOrderToReview> ClientOrderToReviewRepository
        {
            get { return  _clientOrderToReviewRepository ?? ( _clientOrderToReviewRepository = new GenericRepository<ClientOrderToReview>(Context)); }
            set {  _clientOrderToReviewRepository = value; }
        }
    

        private IGenericRepository<ClientReviewScore> _clientReviewScoreRepository;
        public IGenericRepository<ClientReviewScore> ClientReviewScoreRepository
        {
            get { return  _clientReviewScoreRepository ?? ( _clientReviewScoreRepository = new GenericRepository<ClientReviewScore>(Context)); }
            set {  _clientReviewScoreRepository = value; }
        }
    

        private IGenericRepository<ClientSubscription> _clientSubscriptionRepository;
        public IGenericRepository<ClientSubscription> ClientSubscriptionRepository
        {
            get { return  _clientSubscriptionRepository ?? ( _clientSubscriptionRepository = new GenericRepository<ClientSubscription>(Context)); }
            set {  _clientSubscriptionRepository = value; }
        }
    

        private IGenericRepository<Cooker> _cookerRepository;
        public IGenericRepository<Cooker> CookerRepository
        {
            get { return  _cookerRepository ?? ( _cookerRepository = new GenericRepository<Cooker>(Context)); }
            set {  _cookerRepository = value; }
        }
    

        private IGenericRepository<CookerCoupon> _cookerCouponRepository;
        public IGenericRepository<CookerCoupon> CookerCouponRepository
        {
            get { return  _cookerCouponRepository ?? ( _cookerCouponRepository = new GenericRepository<CookerCoupon>(Context)); }
            set {  _cookerCouponRepository = value; }
        }
    

        private IGenericRepository<CookerCuisine> _cookerCuisineRepository;
        public IGenericRepository<CookerCuisine> CookerCuisineRepository
        {
            get { return  _cookerCuisineRepository ?? ( _cookerCuisineRepository = new GenericRepository<CookerCuisine>(Context)); }
            set {  _cookerCuisineRepository = value; }
        }
    

        private IGenericRepository<CookerDeliveryZone> _cookerDeliveryZoneRepository;
        public IGenericRepository<CookerDeliveryZone> CookerDeliveryZoneRepository
        {
            get { return  _cookerDeliveryZoneRepository ?? ( _cookerDeliveryZoneRepository = new GenericRepository<CookerDeliveryZone>(Context)); }
            set {  _cookerDeliveryZoneRepository = value; }
        }
    

        private IGenericRepository<CookerFeedBack> _cookerFeedBackRepository;
        public IGenericRepository<CookerFeedBack> CookerFeedBackRepository
        {
            get { return  _cookerFeedBackRepository ?? ( _cookerFeedBackRepository = new GenericRepository<CookerFeedBack>(Context)); }
            set {  _cookerFeedBackRepository = value; }
        }
    

        private IGenericRepository<CookerGeoIP> _cookerGeoIPRepository;
        public IGenericRepository<CookerGeoIP> CookerGeoIPRepository
        {
            get { return  _cookerGeoIPRepository ?? ( _cookerGeoIPRepository = new GenericRepository<CookerGeoIP>(Context)); }
            set {  _cookerGeoIPRepository = value; }
        }
    

        private IGenericRepository<CookerHoursofOperation> _cookerHoursofOperationRepository;
        public IGenericRepository<CookerHoursofOperation> CookerHoursofOperationRepository
        {
            get { return  _cookerHoursofOperationRepository ?? ( _cookerHoursofOperationRepository = new GenericRepository<CookerHoursofOperation>(Context)); }
            set {  _cookerHoursofOperationRepository = value; }
        }
    

        private IGenericRepository<CookerMenu> _cookerMenuRepository;
        public IGenericRepository<CookerMenu> CookerMenuRepository
        {
            get { return  _cookerMenuRepository ?? ( _cookerMenuRepository = new GenericRepository<CookerMenu>(Context)); }
            set {  _cookerMenuRepository = value; }
        }
    

        private IGenericRepository<CookerOrderReviewReceived> _cookerOrderReviewReceivedRepository;
        public IGenericRepository<CookerOrderReviewReceived> CookerOrderReviewReceivedRepository
        {
            get { return  _cookerOrderReviewReceivedRepository ?? ( _cookerOrderReviewReceivedRepository = new GenericRepository<CookerOrderReviewReceived>(Context)); }
            set {  _cookerOrderReviewReceivedRepository = value; }
        }
    

        private IGenericRepository<CookerOrderReviewSent> _cookerOrderReviewSentRepository;
        public IGenericRepository<CookerOrderReviewSent> CookerOrderReviewSentRepository
        {
            get { return  _cookerOrderReviewSentRepository ?? ( _cookerOrderReviewSentRepository = new GenericRepository<CookerOrderReviewSent>(Context)); }
            set {  _cookerOrderReviewSentRepository = value; }
        }
    

        private IGenericRepository<CookerOrderToReview> _cookerOrderToReviewRepository;
        public IGenericRepository<CookerOrderToReview> CookerOrderToReviewRepository
        {
            get { return  _cookerOrderToReviewRepository ?? ( _cookerOrderToReviewRepository = new GenericRepository<CookerOrderToReview>(Context)); }
            set {  _cookerOrderToReviewRepository = value; }
        }
    

        private IGenericRepository<CookerPaymentMethod> _cookerPaymentMethodRepository;
        public IGenericRepository<CookerPaymentMethod> CookerPaymentMethodRepository
        {
            get { return  _cookerPaymentMethodRepository ?? ( _cookerPaymentMethodRepository = new GenericRepository<CookerPaymentMethod>(Context)); }
            set {  _cookerPaymentMethodRepository = value; }
        }
    

        private IGenericRepository<CookerPlan> _cookerPlanRepository;
        public IGenericRepository<CookerPlan> CookerPlanRepository
        {
            get { return  _cookerPlanRepository ?? ( _cookerPlanRepository = new GenericRepository<CookerPlan>(Context)); }
            set {  _cookerPlanRepository = value; }
        }
    

        private IGenericRepository<CookerPromotion> _cookerPromotionRepository;
        public IGenericRepository<CookerPromotion> CookerPromotionRepository
        {
            get { return  _cookerPromotionRepository ?? ( _cookerPromotionRepository = new GenericRepository<CookerPromotion>(Context)); }
            set {  _cookerPromotionRepository = value; }
        }
    

        private IGenericRepository<CookerReviewScore> _cookerReviewScoreRepository;
        public IGenericRepository<CookerReviewScore> CookerReviewScoreRepository
        {
            get { return  _cookerReviewScoreRepository ?? ( _cookerReviewScoreRepository = new GenericRepository<CookerReviewScore>(Context)); }
            set {  _cookerReviewScoreRepository = value; }
        }
    

        private IGenericRepository<CookerReviewServiceDetail> _cookerReviewServiceDetailRepository;
        public IGenericRepository<CookerReviewServiceDetail> CookerReviewServiceDetailRepository
        {
            get { return  _cookerReviewServiceDetailRepository ?? ( _cookerReviewServiceDetailRepository = new GenericRepository<CookerReviewServiceDetail>(Context)); }
            set {  _cookerReviewServiceDetailRepository = value; }
        }
    

        private IGenericRepository<CookerSpokenLanguage> _cookerSpokenLanguageRepository;
        public IGenericRepository<CookerSpokenLanguage> CookerSpokenLanguageRepository
        {
            get { return  _cookerSpokenLanguageRepository ?? ( _cookerSpokenLanguageRepository = new GenericRepository<CookerSpokenLanguage>(Context)); }
            set {  _cookerSpokenLanguageRepository = value; }
        }
    

        private IGenericRepository<CookerSubscription> _cookerSubscriptionRepository;
        public IGenericRepository<CookerSubscription> CookerSubscriptionRepository
        {
            get { return  _cookerSubscriptionRepository ?? ( _cookerSubscriptionRepository = new GenericRepository<CookerSubscription>(Context)); }
            set {  _cookerSubscriptionRepository = value; }
        }
    

        private IGenericRepository<Coupon> _couponRepository;
        public IGenericRepository<Coupon> CouponRepository
        {
            get { return  _couponRepository ?? ( _couponRepository = new GenericRepository<Coupon>(Context)); }
            set {  _couponRepository = value; }
        }
    

        private IGenericRepository<CouponType> _couponTypeRepository;
        public IGenericRepository<CouponType> CouponTypeRepository
        {
            get { return  _couponTypeRepository ?? ( _couponTypeRepository = new GenericRepository<CouponType>(Context)); }
            set {  _couponTypeRepository = value; }
        }
    

        private IGenericRepository<CuisineType> _cuisineTypeRepository;
        public IGenericRepository<CuisineType> CuisineTypeRepository
        {
            get { return  _cuisineTypeRepository ?? ( _cuisineTypeRepository = new GenericRepository<CuisineType>(Context)); }
            set {  _cuisineTypeRepository = value; }
        }
    

        private IGenericRepository<Currency> _currencyRepository;
        public IGenericRepository<Currency> CurrencyRepository
        {
            get { return  _currencyRepository ?? ( _currencyRepository = new GenericRepository<Currency>(Context)); }
            set {  _currencyRepository = value; }
        }
    

        private IGenericRepository<DeliveryZone> _deliveryZoneRepository;
        public IGenericRepository<DeliveryZone> DeliveryZoneRepository
        {
            get { return  _deliveryZoneRepository ?? ( _deliveryZoneRepository = new GenericRepository<DeliveryZone>(Context)); }
            set {  _deliveryZoneRepository = value; }
        }
    

        private IGenericRepository<Dish> _dishRepository;
        public IGenericRepository<Dish> DishRepository
        {
            get { return  _dishRepository ?? ( _dishRepository = new GenericRepository<Dish>(Context)); }
            set {  _dishRepository = value; }
        }
    

        private IGenericRepository<DishOption> _dishOptionRepository;
        public IGenericRepository<DishOption> DishOptionRepository
        {
            get { return  _dishOptionRepository ?? ( _dishOptionRepository = new GenericRepository<DishOption>(Context)); }
            set {  _dishOptionRepository = value; }
        }
    

        private IGenericRepository<DishOptionsChoice> _dishOptionsChoiceRepository;
        public IGenericRepository<DishOptionsChoice> DishOptionsChoiceRepository
        {
            get { return  _dishOptionsChoiceRepository ?? ( _dishOptionsChoiceRepository = new GenericRepository<DishOptionsChoice>(Context)); }
            set {  _dishOptionsChoiceRepository = value; }
        }
    

        private IGenericRepository<Dispute> _disputeRepository;
        public IGenericRepository<Dispute> DisputeRepository
        {
            get { return  _disputeRepository ?? ( _disputeRepository = new GenericRepository<Dispute>(Context)); }
            set {  _disputeRepository = value; }
        }
    

        private IGenericRepository<DisputeReason> _disputeReasonRepository;
        public IGenericRepository<DisputeReason> DisputeReasonRepository
        {
            get { return  _disputeReasonRepository ?? ( _disputeReasonRepository = new GenericRepository<DisputeReason>(Context)); }
            set {  _disputeReasonRepository = value; }
        }
    

        private IGenericRepository<DisputeStatu> _disputeStatuRepository;
        public IGenericRepository<DisputeStatu> DisputeStatuRepository
        {
            get { return  _disputeStatuRepository ?? ( _disputeStatuRepository = new GenericRepository<DisputeStatu>(Context)); }
            set {  _disputeStatuRepository = value; }
        }
    

        private IGenericRepository<IndustryAverageRating> _industryAverageRatingRepository;
        public IGenericRepository<IndustryAverageRating> IndustryAverageRatingRepository
        {
            get { return  _industryAverageRatingRepository ?? ( _industryAverageRatingRepository = new GenericRepository<IndustryAverageRating>(Context)); }
            set {  _industryAverageRatingRepository = value; }
        }
    

        private IGenericRepository<Invoice> _invoiceRepository;
        public IGenericRepository<Invoice> InvoiceRepository
        {
            get { return  _invoiceRepository ?? ( _invoiceRepository = new GenericRepository<Invoice>(Context)); }
            set {  _invoiceRepository = value; }
        }
    

        private IGenericRepository<Language> _languageRepository;
        public IGenericRepository<Language> LanguageRepository
        {
            get { return  _languageRepository ?? ( _languageRepository = new GenericRepository<Language>(Context)); }
            set {  _languageRepository = value; }
        }
    

        private IGenericRepository<MenuSection> _menuSectionRepository;
        public IGenericRepository<MenuSection> MenuSectionRepository
        {
            get { return  _menuSectionRepository ?? ( _menuSectionRepository = new GenericRepository<MenuSection>(Context)); }
            set {  _menuSectionRepository = value; }
        }
    

        private IGenericRepository<MostPopularDish> _mostPopularDishRepository;
        public IGenericRepository<MostPopularDish> MostPopularDishRepository
        {
            get { return  _mostPopularDishRepository ?? ( _mostPopularDishRepository = new GenericRepository<MostPopularDish>(Context)); }
            set {  _mostPopularDishRepository = value; }
        }
    

        private IGenericRepository<MostPopularSubscription> _mostPopularSubscriptionRepository;
        public IGenericRepository<MostPopularSubscription> MostPopularSubscriptionRepository
        {
            get { return  _mostPopularSubscriptionRepository ?? ( _mostPopularSubscriptionRepository = new GenericRepository<MostPopularSubscription>(Context)); }
            set {  _mostPopularSubscriptionRepository = value; }
        }
    

        private IGenericRepository<Order> _orderRepository;
        public IGenericRepository<Order> OrderRepository
        {
            get { return  _orderRepository ?? ( _orderRepository = new GenericRepository<Order>(Context)); }
            set {  _orderRepository = value; }
        }
    

        private IGenericRepository<OrderHistroy> _orderHistroyRepository;
        public IGenericRepository<OrderHistroy> OrderHistroyRepository
        {
            get { return  _orderHistroyRepository ?? ( _orderHistroyRepository = new GenericRepository<OrderHistroy>(Context)); }
            set {  _orderHistroyRepository = value; }
        }
    

        private IGenericRepository<OrderItem> _orderItemRepository;
        public IGenericRepository<OrderItem> OrderItemRepository
        {
            get { return  _orderItemRepository ?? ( _orderItemRepository = new GenericRepository<OrderItem>(Context)); }
            set {  _orderItemRepository = value; }
        }
    

        private IGenericRepository<OrderItemDishOption> _orderItemDishOptionRepository;
        public IGenericRepository<OrderItemDishOption> OrderItemDishOptionRepository
        {
            get { return  _orderItemDishOptionRepository ?? ( _orderItemDishOptionRepository = new GenericRepository<OrderItemDishOption>(Context)); }
            set {  _orderItemDishOptionRepository = value; }
        }
    

        private IGenericRepository<OrderModelType> _orderModelTypeRepository;
        public IGenericRepository<OrderModelType> OrderModelTypeRepository
        {
            get { return  _orderModelTypeRepository ?? ( _orderModelTypeRepository = new GenericRepository<OrderModelType>(Context)); }
            set {  _orderModelTypeRepository = value; }
        }
    

        private IGenericRepository<OrderStatu> _orderStatuRepository;
        public IGenericRepository<OrderStatu> OrderStatuRepository
        {
            get { return  _orderStatuRepository ?? ( _orderStatuRepository = new GenericRepository<OrderStatu>(Context)); }
            set {  _orderStatuRepository = value; }
        }
    

        private IGenericRepository<OrderSubscription> _orderSubscriptionRepository;
        public IGenericRepository<OrderSubscription> OrderSubscriptionRepository
        {
            get { return  _orderSubscriptionRepository ?? ( _orderSubscriptionRepository = new GenericRepository<OrderSubscription>(Context)); }
            set {  _orderSubscriptionRepository = value; }
        }
    

        private IGenericRepository<OrderSubscriptionHistroy> _orderSubscriptionHistroyRepository;
        public IGenericRepository<OrderSubscriptionHistroy> OrderSubscriptionHistroyRepository
        {
            get { return  _orderSubscriptionHistroyRepository ?? ( _orderSubscriptionHistroyRepository = new GenericRepository<OrderSubscriptionHistroy>(Context)); }
            set {  _orderSubscriptionHistroyRepository = value; }
        }
    

        private IGenericRepository<OrderSubscriptionItem> _orderSubscriptionItemRepository;
        public IGenericRepository<OrderSubscriptionItem> OrderSubscriptionItemRepository
        {
            get { return  _orderSubscriptionItemRepository ?? ( _orderSubscriptionItemRepository = new GenericRepository<OrderSubscriptionItem>(Context)); }
            set {  _orderSubscriptionItemRepository = value; }
        }
    

        private IGenericRepository<OrderSubscriptionItemDishOption> _orderSubscriptionItemDishOptionRepository;
        public IGenericRepository<OrderSubscriptionItemDishOption> OrderSubscriptionItemDishOptionRepository
        {
            get { return  _orderSubscriptionItemDishOptionRepository ?? ( _orderSubscriptionItemDishOptionRepository = new GenericRepository<OrderSubscriptionItemDishOption>(Context)); }
            set {  _orderSubscriptionItemDishOptionRepository = value; }
        }
    

        private IGenericRepository<OrderType> _orderTypeRepository;
        public IGenericRepository<OrderType> OrderTypeRepository
        {
            get { return  _orderTypeRepository ?? ( _orderTypeRepository = new GenericRepository<OrderType>(Context)); }
            set {  _orderTypeRepository = value; }
        }
    

        private IGenericRepository<Payment> _paymentRepository;
        public IGenericRepository<Payment> PaymentRepository
        {
            get { return  _paymentRepository ?? ( _paymentRepository = new GenericRepository<Payment>(Context)); }
            set {  _paymentRepository = value; }
        }
    

        private IGenericRepository<PaymentMethod> _paymentMethodRepository;
        public IGenericRepository<PaymentMethod> PaymentMethodRepository
        {
            get { return  _paymentMethodRepository ?? ( _paymentMethodRepository = new GenericRepository<PaymentMethod>(Context)); }
            set {  _paymentMethodRepository = value; }
        }
    

        private IGenericRepository<PaymentsHistory> _paymentsHistoryRepository;
        public IGenericRepository<PaymentsHistory> PaymentsHistoryRepository
        {
            get { return  _paymentsHistoryRepository ?? ( _paymentsHistoryRepository = new GenericRepository<PaymentsHistory>(Context)); }
            set {  _paymentsHistoryRepository = value; }
        }
    

        private IGenericRepository<Plan> _planRepository;
        public IGenericRepository<Plan> PlanRepository
        {
            get { return  _planRepository ?? ( _planRepository = new GenericRepository<Plan>(Context)); }
            set {  _planRepository = value; }
        }
    

        private IGenericRepository<Promotion> _promotionRepository;
        public IGenericRepository<Promotion> PromotionRepository
        {
            get { return  _promotionRepository ?? ( _promotionRepository = new GenericRepository<Promotion>(Context)); }
            set {  _promotionRepository = value; }
        }
    

        private IGenericRepository<PromotionType> _promotionTypeRepository;
        public IGenericRepository<PromotionType> PromotionTypeRepository
        {
            get { return  _promotionTypeRepository ?? ( _promotionTypeRepository = new GenericRepository<PromotionType>(Context)); }
            set {  _promotionTypeRepository = value; }
        }
    

        private IGenericRepository<RatingCode> _ratingCodeRepository;
        public IGenericRepository<RatingCode> RatingCodeRepository
        {
            get { return  _ratingCodeRepository ?? ( _ratingCodeRepository = new GenericRepository<RatingCode>(Context)); }
            set {  _ratingCodeRepository = value; }
        }
    

        private IGenericRepository<Refund> _refundRepository;
        public IGenericRepository<Refund> RefundRepository
        {
            get { return  _refundRepository ?? ( _refundRepository = new GenericRepository<Refund>(Context)); }
            set {  _refundRepository = value; }
        }
    

        private IGenericRepository<ServingMeasurement> _servingMeasurementRepository;
        public IGenericRepository<ServingMeasurement> ServingMeasurementRepository
        {
            get { return  _servingMeasurementRepository ?? ( _servingMeasurementRepository = new GenericRepository<ServingMeasurement>(Context)); }
            set {  _servingMeasurementRepository = value; }
        }
    

        private IGenericRepository<ServingPrice> _servingPriceRepository;
        public IGenericRepository<ServingPrice> ServingPriceRepository
        {
            get { return  _servingPriceRepository ?? ( _servingPriceRepository = new GenericRepository<ServingPrice>(Context)); }
            set {  _servingPriceRepository = value; }
        }
    

        private IGenericRepository<User> _userRepository;
        public IGenericRepository<User> UserRepository
        {
            get { return  _userRepository ?? ( _userRepository = new GenericRepository<User>(Context)); }
            set {  _userRepository = value; }
        }
    

        private IGenericRepository<UserType> _userTypeRepository;
        public IGenericRepository<UserType> UserTypeRepository
        {
            get { return  _userTypeRepository ?? ( _userTypeRepository = new GenericRepository<UserType>(Context)); }
            set {  _userTypeRepository = value; }
        }
    



        public void Save()
        {
            Context.SaveChanges();
        }

        private bool _disposed;



        public void Dispose(bool disposing)
        {
            if (!_disposed)
            {
                if (disposing)
                {
                    Context.Dispose();
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











 


 

