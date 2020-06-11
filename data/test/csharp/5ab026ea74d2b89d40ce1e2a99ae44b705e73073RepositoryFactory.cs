using WebShop.Data.Repositories;
using WebShop.Data.Repositories.Catalog;
using WebShop.Data.Repositories.Shopping;

namespace WebShop.Data
{
    public interface IRepositoryFactory
    {
        IBookRepository GetBookRepository();
        IAuthorRepository GetAuthorRepository();
        IOrderRepository GetOrderRepository();
        ICustomerRepository GetCustomerRepository();
        IUserRepository GetUserRepository();
    }

    public class RepositoryFactory : IRepositoryFactory
    {
        public IBookRepository GetBookRepository()
        {
            return new BookRepository();
        }

        public IAuthorRepository GetAuthorRepository()
        {
            return new AuthorRepository();
        }

        public IOrderRepository GetOrderRepository()
        {
            return new OrderRepository();
        }

        public ICustomerRepository GetCustomerRepository()
        {
            return new CustomerRepository();
        }

        public IUserRepository GetUserRepository()
        {
            return new UserRepository();
        }
    }
}