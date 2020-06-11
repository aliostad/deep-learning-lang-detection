using System;
using DAL.Generic.Repository.Base;
using Model;

namespace DAL.Generic.UnitofWork
{
    public interface IGenericUnitofWork :IDisposable
    {
       //Model
     IGenericRepository<AddressType> AddressTypeRepository {get;}
    IGenericRepository<Client> ClientRepository {get;}
    IGenericRepository<ClientAddress> ClientAddressRepository {get;}
    IGenericRepository<ClientFeedBack> ClientFeedBackRepository {get;}
    IGenericRepository<ClientOrderReviewReceived> ClientOrderReviewReceivedRepository {get;}
    IGenericRepository<ClientOrderReviewSent> ClientOrderReviewSentRepository {get;}
    IGenericRepository<ClientOrderToReview> ClientOrderToReviewRepository {get;}
    IGenericRepository<ClientReviewScore> ClientReviewScoreRepository {get;}
    IGenericRepository<ClientSubscription> ClientSubscriptionRepository {get;}
    IGenericRepository<Cooker> CookerRepository {get;}
    IGenericRepository<CookerCoupon> CookerCouponRepository {get;}
    IGenericRepository<CookerCuisine> CookerCuisineRepository {get;}
    IGenericRepository<CookerDeliveryZone> CookerDeliveryZoneRepository {get;}
    IGenericRepository<CookerFeedBack> CookerFeedBackRepository {get;}
    IGenericRepository<CookerGeoIP> CookerGeoIPRepository {get;}
    IGenericRepository<CookerHoursofOperation> CookerHoursofOperationRepository {get;}
    IGenericRepository<CookerMenu> CookerMenuRepository {get;}
    IGenericRepository<CookerOrderReviewReceived> CookerOrderReviewReceivedRepository {get;}
    IGenericRepository<CookerOrderReviewSent> CookerOrderReviewSentRepository {get;}
    IGenericRepository<CookerOrderToReview> CookerOrderToReviewRepository {get;}
    IGenericRepository<CookerPaymentMethod> CookerPaymentMethodRepository {get;}
    IGenericRepository<CookerPlan> CookerPlanRepository {get;}
    IGenericRepository<CookerPromotion> CookerPromotionRepository {get;}
    IGenericRepository<CookerReviewScore> CookerReviewScoreRepository {get;}
    IGenericRepository<CookerReviewServiceDetail> CookerReviewServiceDetailRepository {get;}
    IGenericRepository<CookerSpokenLanguage> CookerSpokenLanguageRepository {get;}
    IGenericRepository<CookerSubscription> CookerSubscriptionRepository {get;}
    IGenericRepository<Coupon> CouponRepository {get;}
    IGenericRepository<CouponType> CouponTypeRepository {get;}
    IGenericRepository<CuisineType> CuisineTypeRepository {get;}
    IGenericRepository<Currency> CurrencyRepository {get;}
    IGenericRepository<DeliveryZone> DeliveryZoneRepository {get;}
    IGenericRepository<Dish> DishRepository {get;}
    IGenericRepository<DishOption> DishOptionRepository {get;}
    IGenericRepository<DishOptionsChoice> DishOptionsChoiceRepository {get;}
    IGenericRepository<Dispute> DisputeRepository {get;}
    IGenericRepository<DisputeReason> DisputeReasonRepository {get;}
    IGenericRepository<DisputeStatu> DisputeStatuRepository {get;}
    IGenericRepository<IndustryAverageRating> IndustryAverageRatingRepository {get;}
    IGenericRepository<Invoice> InvoiceRepository {get;}
    IGenericRepository<Language> LanguageRepository {get;}
    IGenericRepository<MenuSection> MenuSectionRepository {get;}
    IGenericRepository<MostPopularDish> MostPopularDishRepository {get;}
    IGenericRepository<MostPopularSubscription> MostPopularSubscriptionRepository {get;}
    IGenericRepository<Order> OrderRepository {get;}
    IGenericRepository<OrderHistroy> OrderHistroyRepository {get;}
    IGenericRepository<OrderItem> OrderItemRepository {get;}
    IGenericRepository<OrderItemDishOption> OrderItemDishOptionRepository {get;}
    IGenericRepository<OrderModelType> OrderModelTypeRepository {get;}
    IGenericRepository<OrderStatu> OrderStatuRepository {get;}
    IGenericRepository<OrderSubscription> OrderSubscriptionRepository {get;}
    IGenericRepository<OrderSubscriptionHistroy> OrderSubscriptionHistroyRepository {get;}
    IGenericRepository<OrderSubscriptionItem> OrderSubscriptionItemRepository {get;}
    IGenericRepository<OrderSubscriptionItemDishOption> OrderSubscriptionItemDishOptionRepository {get;}
    IGenericRepository<OrderType> OrderTypeRepository {get;}
    IGenericRepository<Payment> PaymentRepository {get;}
    IGenericRepository<PaymentMethod> PaymentMethodRepository {get;}
    IGenericRepository<PaymentsHistory> PaymentsHistoryRepository {get;}
    IGenericRepository<Plan> PlanRepository {get;}
    IGenericRepository<Promotion> PromotionRepository {get;}
    IGenericRepository<PromotionType> PromotionTypeRepository {get;}
    IGenericRepository<RatingCode> RatingCodeRepository {get;}
    IGenericRepository<Refund> RefundRepository {get;}
    IGenericRepository<ServingMeasurement> ServingMeasurementRepository {get;}
    IGenericRepository<ServingPrice> ServingPriceRepository {get;}
    IGenericRepository<User> UserRepository {get;}
    IGenericRepository<UserType> UserTypeRepository {get;}


    void Save();
    }
}











 


 

