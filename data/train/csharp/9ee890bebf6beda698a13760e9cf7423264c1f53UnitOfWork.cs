using Model.Base;
using Model.Model;
using Repository.Category;
using Repository.Menu;
using Repository.MenuGroup;
using Repository.Order;
using Repository.OrderDetails;
using Repository.Product;
using Repository.Slide;
using Repository.Vender;
using System;

namespace Repository.Base
{
    public class UnitOfWork : IUnitOfWork
    {
        private TShopDbContext dbContext;
        private ICategoryRepository _categoryRepository;
        private IMenuRepositorycs _menuRepository;
        private IMenuGroupRepository _menuGroupRepository;
        private IOrderRepository _orderRepository;
        private IOrderDetailsRepository _orderDetailsRepository;
        private IProductRepository _productRepository;
        private ISlidetRepository _slidetRepository;
        private IVenderRepository _venderRepository;
        
        public UnitOfWork()
        {
            dbContext = new TShopDbContext();
        }

        public TShopDbContext DbContext
        {
            get { return dbContext ?? (dbContext = new TShopDbContext()); }
        }

        public ICategoryRepository CategoryRepository
        {
            get { return _categoryRepository ?? (_categoryRepository= new CategoryRepository(DbContext)); }
        }

        public IMenuGroupRepository MenuGroupRepository
        {
            get { return _menuGroupRepository ?? (_menuGroupRepository = new MenuGroupRepository(DbContext)); }
        }

        public IOrderRepository OrderRepository
        {
            get { return _orderRepository ?? (_orderRepository = new OrderRepository(DbContext)); }
        }

        public IOrderDetailsRepository OrderDetailsRepository
        {
            get { return _orderDetailsRepository ?? (_orderDetailsRepository = new OrderDetailsRepository(DbContext)); }
        }

        public IProductRepository ProductRepository
        {
            get { return _productRepository ?? (_productRepository = new ProductRepository(DbContext)); }
        }

        public ISlidetRepository SlidetRepository
        {
            get { return _slidetRepository ?? (_slidetRepository = new SlidetRepository(DbContext)); }
        }

        public IVenderRepository VenderRepository
        {
            get { return _venderRepository ?? (_venderRepository = new VenderRepository(DbContext)); }
        }

        public IMenuRepositorycs MenuRepositorycs
        {
            get { return _menuRepository ?? (_menuRepository = new MenuRepository(DbContext)); }
        }

        public void Commit()
        {
            try
            {
                DbContext.SaveChanges();
            }
            catch (Exception)
            {

                throw;
            }
            finally
            {
                ResetRepositories();
            }
        }

        public void Dispose()
        {
            //Disposing(true);
            GC.SuppressFinalize(this);
        }

        private void Disposing(bool v)
        {
            throw new NotImplementedException();
        }

        private void ResetRepositories()
        {
            _categoryRepository = null;
            _menuRepository = null;
            _menuGroupRepository = null;
            _orderRepository = null;
            _orderDetailsRepository = null;
            _productRepository = null;
            _slidetRepository = null;
            _venderRepository = null;
        }
    }
}
