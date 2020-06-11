namespace GameStore.Models.Repositories
{
    public interface IUnitOfWork
    {
        ICommentRepository CommentRepository { get; }
        
        IGameRepository GameRepository { get; }
        
        IGenreRepository GenreRepository { get; }
        
        IPlatformTypeRepository PlatformTypeRepository { get; }

        IPublisherRepository PublisherRepository { get; }

        IOrderRepository OrderRepository { get; }

        IPaymentRepository PaymentRepository { get; }

        IShipperRepository ShipperRepository { get; }

        IUserRepository UserRepository { get; }

        void Save();
    }
}