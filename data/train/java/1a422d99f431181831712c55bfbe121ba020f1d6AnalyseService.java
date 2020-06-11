package edu.nju.bookHouse.service;

public class AnalyseService {
	private InventoryService inventoryService;
	private UserService userService;
	private BookService bookService;
	private CategoryService categoryService;
	private CouponsService couponsService;
	private OrderService orderService;
	
	public void analyse() {
		inventoryService.newAnalyse();
		userService.analyse();
		categoryService.analyse();
		bookService.analyse();
		couponsService.analyse();
		orderService.analyse();
	}

	public void setInventoryService(InventoryService inventoryService) {
		this.inventoryService = inventoryService;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}

	public void setCategoryService(CategoryService categoryService) {
		this.categoryService = categoryService;
	}

	public void setBookService(BookService bookService) {
		this.bookService = bookService;
	}

	public void setCouponsService(CouponsService couponsService) {
		this.couponsService = couponsService;
	}

	public void setOrderService(OrderService orderService) {
		this.orderService = orderService;
	}
}
