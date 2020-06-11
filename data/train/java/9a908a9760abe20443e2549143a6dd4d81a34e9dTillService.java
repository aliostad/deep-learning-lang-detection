package com.example.supermarket;

public class TillService {

	private final AuthenticationService authenticationService;
	private final ProductService productService;
	private final OrderService orderService;
	private Order order;
	
	public TillService(AuthenticationService authenticationService, 
					   ProductService productService,
					   OrderService orderService) {
		this.authenticationService = authenticationService;
		this.productService = productService;
		this.orderService = orderService;
	}

	public void startShopping(Customer customer) throws UserNotAllowedException {
		if (!authenticationService.authenticateCustomer(customer)) {
			throw new UserNotAllowedException();
		}
		order = orderService.createOrder(customer);
	}
	
	public void scanItem(String barcode) {
		Product product = productService.lookupProductByBarcode(barcode);
		order.addItem(product);
	}
	
}
