package service.order;

import entity.order.Order;
import exceptions.BusinessException;
import repository.factory.RepositoryFactory;
import repository.order.OrderRepository;

/**
 * @author Arsalan
 */
public class DefaultOrderService implements OrderService {

    private OrderRepository orderRepository;

    public DefaultOrderService(RepositoryFactory factory) {
        this.orderRepository = factory.getOrderRepository();
    }

    @Override
    public void createOrder(Order order) throws BusinessException {
        orderRepository.createOrder(order);
    }

    @Override
    public int getLastOrderId() {
        return orderRepository.getLastOrderId();
    }
}
