using DataAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repositories
{
    public class UnitOfWork
    {
        private OnlineShopEntities Context = new OnlineShopEntities();



        private CategoryRepository categoryRepository;
        private CityRepository cityRepository;
        private PCsRepository pcsRepository;
        private ProductRepository productRepository;
        private SalesRepository salesRepository;
        private SmartphonesRepository smartphonesRepository;
        private UserRepository userRepository;


        public CategoryRepository CategoryRepository
        {
            get
            {
                if (this.categoryRepository == null)
                {
                    this.categoryRepository = new CategoryRepository(Context);
                }
                return categoryRepository;
            }
        }

        public CityRepository CityRepository
        {
            get
            {
                if (this.cityRepository == null)
                {
                    this.cityRepository = new CityRepository(Context);
                }
                return cityRepository;
            }
        }

        public PCsRepository PCsRepository
        {
            get
            {
                if (this.pcsRepository == null)
                {
                    this.pcsRepository = new PCsRepository(Context);
                }
                return pcsRepository;
            }
        }

        public ProductRepository ProductRepository
        {
            get
            {
                if (this.productRepository == null)
                {
                    this.productRepository = new ProductRepository(Context);
                }
                return productRepository;
            }
        }

        public SalesRepository SalesRepository
        {
            get
            {
                if (this.salesRepository == null)
                {
                    this.salesRepository = new SalesRepository(Context);
                }
                return salesRepository;
            }
        }

        public SmartphonesRepository SmartphonesRepository
        {
            get
            {
                if (this.smartphonesRepository == null)
                {
                    this.smartphonesRepository = new SmartphonesRepository(Context);
                }
                return smartphonesRepository;
            }
        }

        public UserRepository UserRepository
        {
            get
            {
                if (this.userRepository == null)
                {
                    this.userRepository = new UserRepository(Context);
                }
                return userRepository;
            }
        }

        public int Save()
        {
            return Context.SaveChanges();
        }
    }
}
