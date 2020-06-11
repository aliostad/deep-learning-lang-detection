using System;
using QuanLyDonHang.Common.DbHelper;
using QuanLyDonHang.Data.MongoDb.Repository;

namespace QuanLyDonHang.Data.MongoDb
{
    public class UnitOfWork : IDisposable
    {
        private UserRepository _userRepository;

        private CustomerGroupRepository _customerGroupRepository;

        private CustomerRepository _customerRepository;

        private ProductGroupRepository _productGroupRepository;

        private ProductUnitRepository _productUnitRepository;

        private ProductRepository _productRepository;

        private OrderRepository _orderRepository;

        public UnitOfWork(MongoHelper helper)
        {
            DataHelper = helper;
        }

        public MongoHelper DataHelper { get; set; }

        public UserRepository UserRepository => _userRepository ?? (_userRepository = new UserRepository(DataHelper,
                                                                                                         User.COLLECTIONNAME));

        public CustomerGroupRepository CustomerGroupRepository => _customerGroupRepository ?? (_customerGroupRepository = new CustomerGroupRepository(DataHelper,
                                                                                                                                                      CustomerGroup.COLLECTIONNAME));

        public CustomerRepository CustomerRepository => _customerRepository ?? (_customerRepository = new CustomerRepository(DataHelper,
                                                                                                                             Customer.COLLECTIONNAME));

        public ProductGroupRepository ProductGroupRepository => _productGroupRepository ?? (_productGroupRepository = new ProductGroupRepository(DataHelper,
                                                                                                                                                 ProductGroup.COLLECTIONNAME));

        public ProductUnitRepository ProductUnitRepository => _productUnitRepository ?? (_productUnitRepository = new ProductUnitRepository(DataHelper,
                                                                                                                                            ProductUnit.COLLECTIONNAME));

        public ProductRepository ProductRepository => _productRepository ?? (_productRepository = new ProductRepository(DataHelper,
                                                                                                                        Product.COLLECTIONNAME));

        public OrderRepository OrderRepository => _orderRepository ?? (_orderRepository = new OrderRepository(DataHelper,
                                                                                                              Order.COLLECTIONNAME));

        #region IDisposable Members

        public void Dispose()
        {
        }

        #endregion
    }
}
