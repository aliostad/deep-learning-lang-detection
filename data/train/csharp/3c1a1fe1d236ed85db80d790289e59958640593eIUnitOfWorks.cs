using GameStore.DAL.Repositories.GameStore.Interfaces;
using GameStore.DAL.Repositories.Northwind.Interfaces;

namespace GameStore.DAL.UnitOfWorks
{
    public interface IUnitOfWorks
    {
        IGameRepository GameRepository { get; }

        ICommentRepository CommentRepository { get; }

        IGenreRepository GenreRepository { get; }

        IPlatformTypeRepository PlatformTypeRepository { get; }

        IPublisherRepository PublisherRepository { get; }

        IOrderRepository OrderRepository { get; }

        IOrderDetailsRepository OrderDetailsRepository { get; }

        IBasketRepository BasketRepository { get; }

        IBasketDetailsRepository BasketDetailsRepository { get; }

        IUserRepository UserRepository { get; }

        IRoleRepository RoleRepository { get; }

        IShipperRepository ShipperRepository { get; }

        IStatisticRepository StatisticRepository { get; }

        IBanRepository BanRepository { get; }

        void Save();
    }
}
