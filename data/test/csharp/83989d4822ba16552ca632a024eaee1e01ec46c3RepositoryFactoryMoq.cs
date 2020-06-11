namespace PVT.Q1._2017.Shop.Tests.Moq
{
    using System;
    using global::Shop.DAL.Infrastruture;

    public class RepositoryFactoryMoq : IRepositoryFactory
    {
        private readonly AlbumRepositoryMoq _albumRepositoryMoq = new AlbumRepositoryMoq();
        private readonly ArtistRepositoryMoq _artistRepositoryMoq = new ArtistRepositoryMoq();
        private readonly TrackRepositoryMoq _trackRepositoryMoq = new TrackRepositoryMoq();
        private readonly CurrencyRepositoryMoq _currencyRepositoryMoq = new CurrencyRepositoryMoq();
        private readonly AlbumPriceRepositoryMoq _albumPriceRepositoryMoq = new AlbumPriceRepositoryMoq();
        private readonly CurrencyRateRepositorMoq _currencyRateRepositorMoq = new CurrencyRateRepositorMoq();
        private readonly FeedbackRepositoryMoq _feedbackRepositoryMoq = new FeedbackRepositoryMoq();
        private readonly GenreRepositoryMoq _genreRepositoryMoq = new GenreRepositoryMoq();
        private readonly PriceLevelRepositoryMoq _priceLevelRepositoryMoq = new PriceLevelRepositoryMoq();
        private readonly TrackPriceRepositoryMoq _trackPriceRepositoryMoq = new TrackPriceRepositoryMoq();
        private readonly UserDataRepositoryMoq _userDataRepositoryMoq = new UserDataRepositoryMoq();
        private readonly VoteRepositoryMoq _voteRepositoryMoq = new VoteRepositoryMoq();
        private readonly AlbumTrackRelationRepositoryMoq _albumTrackRelationRepositoryMoq = new AlbumTrackRelationRepositoryMoq();
        private readonly UserRepositoryMoq _userRepositoryMoq = new UserRepositoryMoq();
        private readonly SettingRepositoryMoq _settingRepositoryMoq = new SettingRepositoryMoq();
        private readonly OrderTrackRepositoryMoq _orderTrackRepositoryMoq = new OrderTrackRepositoryMoq();
        private readonly OrderAlbumRepositoryMoq _orderAlbumRepositoryMoq = new OrderAlbumRepositoryMoq();
        private readonly PurchasedTrackRepositoryMoq _purchasedTrackRepositoryMoq = new PurchasedTrackRepositoryMoq();
        private readonly PurchasedAlbumRepositoryMoq _purchasedAlbumRepositoryMoq = new PurchasedAlbumRepositoryMoq();

        private readonly PaymentTransactionRepositoryMoq _paymentTransactionRepositoryMoq = new PaymentTransactionRepositoryMoq();
        private readonly UserPaymentMethodRepositoryMoq _userPaymentMethodRepositoryMoq = new UserPaymentMethodRepositoryMoq();

        public IAlbumRepository GetAlbumRepository()
        {
            return _albumRepositoryMoq.Repository;
        }

        public IArtistRepository GetArtistRepository()
        {
            return _artistRepositoryMoq.Repository;
        }

        public ITrackRepository GetTrackRepository()
        {
            return _trackRepositoryMoq.Repository;
        }

        public ICurrencyRepository GetCurrencyRepository()
        {
            return _currencyRepositoryMoq.Repository;
        }

        public IAlbumPriceRepository GetAlbumPriceRepository()
        {
            return _albumPriceRepositoryMoq.Repository;
        }

        public ICurrencyRateRepository GetCurrencyRateRepository()
        {
            return _currencyRateRepositorMoq.Repository;
        }

        public IFeedbackRepository GetFeedbackRepository()
        {
            return _feedbackRepositoryMoq.Repository;
        }

        public IGenreRepository GetGenreRepository()
        {
            return _genreRepositoryMoq.Repository;
        }

        public IPriceLevelRepository GetPriceLevelRepository()
        {
            return _priceLevelRepositoryMoq.Repository;
        }

        public ITrackPriceRepository GetTrackPriceRepository()
        {
            return _trackPriceRepositoryMoq.Repository;
        }

        public IUserDataRepository GetUserDataRepository()
        {
            return _userDataRepositoryMoq.Repository;
        }

        public IVoteRepository GetVoteRepository()
        {
            return _voteRepositoryMoq.Repository;
        }

        public IAlbumTrackRelationRepository GetAlbumTrackRelationRepository()
        {
            return _albumTrackRelationRepositoryMoq.Repository;
        }

        public IUserPaymentMethodRepository GetUserPaymentMethodRepository()
        {
            return _userPaymentMethodRepositoryMoq.Repository;
        }
        
        public IPaymentTransactionRepository GetPaymentTransactionRepository()
        {
            return _paymentTransactionRepositoryMoq.Repository;
        }

        public IUserRepository GetUserRepository()
        {
            return _userRepositoryMoq.Repository;
        }

        public ISettingRepository GetSettingRepository()
        {
            return _settingRepositoryMoq.Repository;
        }

        public IOrderTrackRepository GetOrderTrackRepository()
        {
            return _orderTrackRepositoryMoq.Repository;
        }

        public IOrderAlbumRepository GetOrderAlbumRepository()
        {
            return _orderAlbumRepositoryMoq.Repository;
        }

        public IPurchasedTrackRepository GetPurchasedTrackRepository()
        {
            return _purchasedTrackRepositoryMoq.Repository;
        }

        public IPurchasedAlbumRepository GetPurchasedAlbumRepository()
        {
            return _purchasedAlbumRepositoryMoq.Repository;
        }

        public ICountryRepository GetCountryRepository()
        {
            throw new NotImplementedException();
        }
    }
}