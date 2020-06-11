using ECmmerce.Data.Infrastructure;
using ECmmerce.Data.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ECmmerce.Data.Infrasctructure
{
    public class UnitOfWork : IUnitOfWork
    {
        private ecommerceContext dataContext;
        IDatabaseFactory dbFactory;
        public UnitOfWork(IDatabaseFactory dbFactory)
        {
            this.dbFactory = dbFactory;
        }






        private IAddressRepository addressRepository;
        public IAddressRepository AddressRepository
        {
            get
            { return addressRepository = new AddressRepository(dbFactory); }
        }

        private ICategoryRepository categoryRepository;
        public ICategoryRepository CategoryRepository
        {
            get
            { return categoryRepository = new CategoryRepository(dbFactory); }
        }



        private ICommisionRepository commisionRepository;
        public ICommisionRepository CommisionRepository
        {
            get
            { return commisionRepository = new CommisionRepository(dbFactory); }
        }

        private ICreditCardRepository creditCardRepository;
        public ICreditCardRepository CreditCardRepository
        {
            get
            { return creditCardRepository = new CreditCardRepository(dbFactory); }
        }

        private IGouvernoratRepository gouvernoratRepository;
        public IGouvernoratRepository GouvernoratRepository
        {
            get
            { return gouvernoratRepository = new GouvernoratRepository(dbFactory); }
        }

        private IOrderItemRepository orderItemRepository;
        public IOrderItemRepository OrderItemRepository
        {
            get
            { return orderItemRepository = new OrderItemRepository(dbFactory); }
        }

        private IOrderRepository orderRepository;
        public IOrderRepository OrderRepository
        {
            get
            { return orderRepository = new OrderRepository(dbFactory); }
        }



        private IPictureRepository pictureRepository;
        public IPictureRepository PictureRepository
        {
            get
            { return pictureRepository = new PictureRepository(dbFactory); }
        }


        private IProductItemRepository productItemRepository;
        public IProductItemRepository ProductItemRepository
        {
            get
            { return productItemRepository = new ProductItemRepository(dbFactory); }
        }


        private IProductItemSupplierRepository productItemSupplierRepository;
        public IProductItemSupplierRepository ProductItemSupplierRepository
        {
            get
            { return productItemSupplierRepository = new ProductItemSupplierRepository(dbFactory); }
        }


        private IProductRepository productRepository;
        public IProductRepository ProductRepository
        {
            get
            { return productRepository = new ProductRepository(dbFactory); }
        }


        private IPromotionRepository promotionRepository;
        public IPromotionRepository PromotionRepository
        {
            get
            { return promotionRepository = new PromotionRepository(dbFactory); }
        }


        private IReclamationRepository reclamationRepository;
        public IReclamationRepository ReclamationRepository
        {
            get
            { return reclamationRepository = new ReclamationRepository(dbFactory); }
        }


        private IRecommendationRepository recommendationRepository;
        public IRecommendationRepository RecommendationRepository
        {
            get
            { return recommendationRepository = new RecommendationRepository(dbFactory); }
        }


        private IReviewRepository reviewRepository;
        public IReviewRepository ReviewRepository
        {
            get
            { return reviewRepository = new ReviewRepository(dbFactory); }
        }




        private IShoppingCartRepository shoppingCartRepository;
        public IShoppingCartRepository ShoppingCartRepository
        {
            get
            { return shoppingCartRepository = new ShoppingCartRepository(dbFactory); }
        }


        private IUserRepository userRepository;
        public IUserRepository UserRepository
        {
            get
            { return userRepository = new UserRepository(dbFactory); }
        }


        protected ecommerceContext DataContext
        {
            get
            {
                return dataContext = dbFactory.DataContext;
            }
        }

        public void Commit() { DataContext.SaveChanges(); }
        public void Dispose() { dbFactory.Dispose(); }
    }

}
