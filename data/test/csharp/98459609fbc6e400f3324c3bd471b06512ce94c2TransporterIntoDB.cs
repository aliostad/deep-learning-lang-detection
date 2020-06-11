using Model;

namespace DAL.classes
{
   public class TransporterIntoDb
    {
      
       
        private readonly ManagerRepository _managerRepository;
        public ManagerRepository ManagerRepository
            {
                get { return _managerRepository; }
            }
        private readonly OrderRepository _orderRepository;
        public OrderRepository OrderRepository
            {
                get { return _orderRepository; }
            }
        private readonly ProductRepository _productRepository;
        public ProductRepository ProductRepository
            {
                get { return _productRepository; }
            }
        private readonly CustomerRepository _customerRepository;
        public CustomerRepository CustomerRepository
            {
                get { return _customerRepository; }
            } 

       public TransporterIntoDb()
        {
          SaleContainer _context= new SaleContainer();
          _managerRepository = new ManagerRepository(_context);
          _orderRepository = new OrderRepository(_context);
          _productRepository = new ProductRepository(_context);
          _customerRepository = new CustomerRepository(_context);
           
        }





    }
}
