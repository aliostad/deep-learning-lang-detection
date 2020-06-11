using RepositoryPattern.Areas.Admin.Models;
using RepositoryPattern.Controllers;
using RepositoryPattern.Model.Catalog;
using RepositoryPattern.Model.Customers;
using RepositoryPattern.Model.Media;
using RepositoryPattern.Model.Sales;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace RepositoryPattern.Areas.Admin.Controllers
{
    public class HomeController : BaseController
    {
        public HomeController(ICategoryRepository categoryRepository
            , IProductRepository productRepository, IPictureRepository pictureRepository,
            IOrderRepository orderRepository, IOrderItemsRepository orderItemRepository,
            IUserRepository userRepository, IProductVariationRepository prdVariationRepo, ICustomerInfoRepository customerRepository)
        {
            this._categoryRepository = categoryRepository;
            this._productRepository = productRepository;
            this._pictureRepository = pictureRepository;
            this._orderRepository = orderRepository;
            this._orderItemRepository = orderItemRepository;
            this._userRepository = userRepository;
            this._prdVariationRepo = prdVariationRepo;
            this._customerRepository = customerRepository;
        }

        private readonly ICategoryRepository _categoryRepository;
        private readonly IProductRepository _productRepository;
        private readonly IPictureRepository _pictureRepository;
        private readonly IOrderRepository _orderRepository;
        private readonly IOrderItemsRepository _orderItemRepository;
        private readonly IUserRepository _userRepository;
        private readonly IProductVariationRepository _prdVariationRepo;
        private readonly ICustomerInfoRepository _customerRepository;
        
        [Authorize(Roles = "Admin")]
        public ActionResult Index()
        {
            var product = _productRepository.GetAllProduct().Count();
            var customer = _customerRepository.GetAllCustomersInfo().Count();
            var orderItem = _orderItemRepository.GetAllOrderItems().Count();

            var homeDisplay = new HomeDisplay
                                {
                                    CustomerCount = customer,
                                    WishListCount = orderItem,
                                    ProductCount = product
                                };


            return View(homeDisplay);
        }

    }
}
