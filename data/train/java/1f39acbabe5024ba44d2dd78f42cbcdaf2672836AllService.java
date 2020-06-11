package service;

public class AllService {
	private UserinfoService userinfoService;
	private BookinfoService bookinfoService;
	private OrderinfoService orderinfoService;
	
	public BookinfoService getBookinfoService() {
		return bookinfoService;
	}

	public void setBookinfoService(BookinfoService bookinfoService) {
		this.bookinfoService = bookinfoService;
	}

	public UserinfoService getUserinfoService() {
		return userinfoService;
	}

	public void setUserinfoService(UserinfoService userinfoService) {
		this.userinfoService = userinfoService;
	}

	public OrderinfoService getOrderinfoService() {
		return orderinfoService;
	}

	public void setOrderinfoService(OrderinfoService orderinfoService) {
		this.orderinfoService = orderinfoService;
	}
	
}
