using ROM.Data.Model;
using ROM.Data.Repository;
using ROM.Services.Data.Contracts;
using System.Linq;

namespace ROM.Services.Data
{
    public class HomeService : IHomeService
    {
        private readonly IEfRepository<Restaurant> restaurantRepository;
        private readonly IEfRepository<Table> tableRepository;
        private readonly IEfRepository<Product> productRepository;

        public HomeService(
            IEfRepository<Restaurant> restaurantRepository, 
            IEfRepository<Table> tableRepository, 
            IEfRepository<Product> productRepository)
        {
            this.restaurantRepository = restaurantRepository;
            this.tableRepository = tableRepository;
            this.productRepository = productRepository;
        }

        public IQueryable<Restaurant> GetAllRestaurants()
        {
            return this.restaurantRepository.All;
        }

        public IQueryable<Table> GetAllTables()
        {
            return this.tableRepository.All;
        }

        public IQueryable<Product> GetAllProducts()
        {
            return this.productRepository.All;
        }
    }
}
