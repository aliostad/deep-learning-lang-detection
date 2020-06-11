//-----------------------------------------------------------------------
// Базовый сервис. Содержит общие репозитории.
//-----------------------------------------------------------------------
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BookMarket.DbInfrastructure;

namespace BookMarket.Services
{
    public class BaseService //: BookMarketDbContext
    {
        protected CommonRepository _commonRepository = new CommonRepository();
        protected IDbModelRepository _addressRepository =
            new AddressRepository();
        protected IDbModelRepository _authorRepository =
            new AuthorRepository();
        protected IDbModelRepository _basketRepository = 
            new BasketRepository();
        protected IDbModelRepository _basketItemRepository =
            new BasketItemRepository();
        protected IDbModelRepository _bookRepository = new BookRepository();
        protected IDbModelRepository _bookTagRepository =
            new BookTagRepository();
        protected IDbModelRepository _bookVariableInfoRepository =
            new BookVariableInfoRepository();
        protected IDbModelRepository _cityRepository = new CityRepository();
        protected IDbModelRepository _individualRepository =
            new IndividualRepository();
        protected IDbModelRepository _languageRepository =
            new LanguageRepository();
        protected IDbModelRepository _paymentRepository =
            new PaymentRepository();
        protected IDbModelRepository _publisherRepository = new PublisherRepository();
        protected IDbModelRepository _shopRepository = new ShopRepository();
        protected IDbModelRepository _streetRepository = new StreetRepository();
        protected IDbModelRepository _streetTypeRepository =
            new StreetTypeRepository();
        protected IDbModelRepository _userProfileRepository =
            new UserProfileRepository();
        protected IDbModelRepository _w1PaymentRepository =
            new W1PaymentRepository();
    }
}