using Core.DAL.Repositories.Implementations;
using Core.DAL.Repositories.Interfaces;
using Core.Model;
using System;

namespace Core.DAL.Repositories
{
    public class UnitOfWork : IDisposable
    {
        private OnlineShopEntities context = new OnlineShopEntities();
        private IUserRepository userRepository;
        private ICategoryRepository categoryRepository;
        private IItemRepository itemRepository;
        private IOrderRepository orderRepository;

        public IUserRepository UserRepository
        {
            get
            {
                if (userRepository == null)
                {
                    userRepository = new UserRepository(context);
                }

                return userRepository;
            }
        }

        public ICategoryRepository CategoryRepository
        {
            get
            {
                if (categoryRepository == null)
                {
                    categoryRepository = new CategoryRepository(context);
                }

                return categoryRepository;
            }
        }

        public IItemRepository ItemRepository
        {
            get
            {
                if (itemRepository == null)
                {
                    itemRepository = new ItemRepository(context);
                }

                return itemRepository;
            }
        }

        public IOrderRepository OrderRepository
        {
            get
            {
                if (orderRepository == null)
                {
                    orderRepository = new OrderRepository(context);
                }

                return orderRepository;
            }
        }

        public void Save()
        {
            context.SaveChanges();
        }

        private bool disposed = false;

        protected virtual void Dispose(bool disposing)
        {
            if (!disposed)
            {
                if (disposing)
                {
                    context.Dispose();
                }
            }

            disposed = true;
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
    }
}
