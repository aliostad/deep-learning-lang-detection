


namespace Game_Store.DAL.Repository.Abstract
{
    public interface IUnitOfWork
    {
        ICommentRepository CommentRepository { get; }
        IGenreRepository GenreRepository { get; }
        IPlatformTypeRepository PlatformTypeRepository { get; }
        IRepositoryGame GameRepository { get; }
        IPublisherRepository PublisherRepository { get; }
        IOrderRepository OrderRepository { get; }
        IOrderDetailsRepository OrderDetailsRepository { get; }
        IShipperRepository ShipperRepository { get; }
        IUserRepository UserRepository { get; }
        IRoleRepository RoleRepository { get; }

        void Save();
    }
}
