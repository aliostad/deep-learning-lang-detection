using System;

namespace TradingPlatform.DAL.Core.Interfaces
{
    public interface IUow
    {
        Lazy<IMarketRepository> MarketRepository { get; }

        Lazy<IOrderRepository> OrderRepository { get; }

        Lazy<IOrderStatusRepository> OrderStatusRepository { get; }

        Lazy<IOrderTypeRepository> OrderTypeRepository { get; }

        Lazy<IPriceRepository> PriceRepository { get; }

        Lazy<ITradingAccountRepository> TradingAccountRepository { get; }

        Lazy<IUserRepository> UserRepository { get; }

        void Commit();
    }
}
