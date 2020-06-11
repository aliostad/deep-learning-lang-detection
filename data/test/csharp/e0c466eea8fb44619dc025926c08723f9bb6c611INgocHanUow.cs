using System;

namespace NgocHan.Contracts
{
    public interface INgocHanUow: IDisposable
    {

        ICategoryRepository CategoryRepository { get; }

        IContactRepository ContactRepository { get; }

        IProductRepository ProductRepository { get; }

        IShopRepository ShopRepository { get; }
        
        ISlideRepository SlideRepository { get; }

        IBlogRepository BlogRepository { get; }

        IAccountRepository AccountRepository { get; }

        void Commit();

        IRepository<TEntity> Repository<TEntity>() where TEntity : class;
    }
}
