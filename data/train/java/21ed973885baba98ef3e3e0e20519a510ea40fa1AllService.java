package service;

public class AllService {
	private UserinfoService userinfoService;
	private BookinfoService bookinfoService;
	private OrderinfoService orderinfoService;
	private StatisticService statisticService;
	
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

	public StatisticService getStatisticService() {
		return statisticService;
	}

	public void setStatisticService(StatisticService statisticService) {
		this.statisticService = statisticService;
	}
	
	
}
