namespace UoW.NHibernate
{
    public class BigRepository : IBigRepository
    {
        private readonly IOrderRepository _orderRepository;

        private readonly IUserRepository _userRepository;

        public BigRepository(IOrderRepository orderRepository, IUserRepository userRepository)
        {
            _orderRepository = orderRepository;
            _userRepository = userRepository;
        }

        public void CreateUsersAndOrders()
        {
            _orderRepository.CreateOrders();
            _userRepository.CreateUsers();
        }
    }
}
