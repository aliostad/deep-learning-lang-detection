using ManicureDomain.Abstract;

namespace Data.EntityFramework.Infrastructure
{
    public interface IUnitOfWork
    {
        ICategoryRepository CategoryRepository { get; }
        ICityRepository CityRepository { get; }
        IClientRepository ClientRepository { get; }
        IItemRepository ItemRepository { get; }
        IOrderRepository OrderRepository { get; }
        IPurchasePlaceRepository PurchasePlaceRepository { get; }
        IPurchaseRepository PurchaseRepository { get; }
        IOrderItemRepository OrderItemRepository { get; }

        void Commit();
    }
}
