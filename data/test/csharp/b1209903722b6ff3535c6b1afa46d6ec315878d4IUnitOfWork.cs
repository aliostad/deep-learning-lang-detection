using Data.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Data.Infrastructure
{
    public interface IUnitOfWork : IDisposable
    {
        void Commit();

        IAdminRepository AdminRepository { get; }
        IAdRepository AdRepository { get; }
        IAyleRepository AyleRepository { get; }
        ICaddyRepository CaddyRepository { get; }
        IClientRepository ClientRepository { get; }
        IItemShoppingRepository ItemShoppingRepository { get; }
        ILogRepository LogRepository { get; }
        IProductRepository ProductRepository { get; }
        IShoppingListRepository ShoppingListRepository { get; }

    }

}
