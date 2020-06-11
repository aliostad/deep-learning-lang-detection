using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HBoop.Model.Bson.Entities;
using HBoop.DataAccess.Bson;

namespace HBoop.Business.Layer
{
    public class BusinessLayer : IBusinessLayer, IDisposable
    {
        public IManager<Address> AddressRepository { get; }
        public IManager<Beneficiary> BeneficiaryRepository { get; }
        public IManager<Affiliate> AffiliateRepository { get; }
        public IManager<BookingDetail> BookingDetailRepository { get; }
        public IManager<Booking> BookingRepository { get; }
        public IManager<Comment> CommentRepository { get; }
        public IManager<CreditCard> CreditCardRepository { get; }
        public IManager<Currency> CurrencyRepository { get; }
        public IManager<Discount> DiscountRepository { get; }
        public IManager<Language> LanguageRepository { get; }
        public IManager<Media> MediaRepository { get; }
        public IManager<Message> MessageRepository { get; }
        public IManager<Notification> NotificationRepository { get; }
        public IManager<OrderDetail> OrderDetailRepository { get; }
        public IManager<Order> OrderRepository { get; }
        public IManager<Person> PersonRepository { get; }
        public IManager<Price> PriceRepository { get; }
        public IManager<ProductCategory> ProductCategoryRepository { get; }
        public IManager<Product> ProductRepository { get; }
        public IManager<Role> RoleRepository { get; }
        public IManager<ShipMethod> ShipMethodRepository { get; }
        public IManager<Store> StoreRepository { get; }
        public IManager<User> UserRepository { get; }
        public IManager<Vat> VatRepository { get; }

        public BusinessLayer(
            IManager<Address> addressRepository,
            IManager<Beneficiary> beneficiaryRepository,
            IManager<Affiliate> affiliateRepository,
            IManager<Comment> commentRepository,
            IManager<Comment> CommentRepository,
            IManager<CreditCard> creditCardRepository,
            IManager<Currency> currencyRepository,
            IManager<Discount> discountRepository,
            IManager<Language> languageRepository,
            IManager<Media> mediaRepository,
            IManager<Message> messageRepository,
            IManager<Notification> notificationRepository,
            IManager<Order> OrderRepository,
            IManager<OrderDetail> orderDetailRepository,
            IManager<Person> personRepository,
            IManager<Booking> bookingRepository,
            IManager<BookingDetail> bookingDetailRepository,
            IManager<Product> productRepository,
            IManager<ProductCategory> productCategoryRepository,
            IManager<Role> roleRepository,
            IManager<ShipMethod> shipMethodRepository,
            IManager<Store> storeRepository,
            IManager<User> userRepository,
            IManager<Vat> vatRepository
            )
        {
            this.AddressRepository = addressRepository;
            this.BeneficiaryRepository = beneficiaryRepository;
            this.AffiliateRepository = affiliateRepository;
            this.CommentRepository = commentRepository;
            this.CreditCardRepository = creditCardRepository;
            this.CurrencyRepository = currencyRepository;
            this.DiscountRepository = discountRepository;
            this.LanguageRepository = languageRepository;
            this.MediaRepository = mediaRepository;
            this.MessageRepository = messageRepository;
            this.NotificationRepository = notificationRepository;
            this.OrderRepository = OrderRepository;
            this.OrderDetailRepository = orderDetailRepository;
            this.PersonRepository = personRepository;
            this.BookingRepository = bookingRepository;
            this.BookingDetailRepository = bookingDetailRepository;
            this.RoleRepository = roleRepository;
            this.ProductRepository = productRepository;
            this.ProductCategoryRepository = productCategoryRepository;
            this.ShipMethodRepository = shipMethodRepository;
            this.StoreRepository = storeRepository;
            this.UserRepository = userRepository;
            this.VatRepository = vatRepository;
        }
        public void Dispose()
        {
            GC.SuppressFinalize(this);
        }
    }
}
