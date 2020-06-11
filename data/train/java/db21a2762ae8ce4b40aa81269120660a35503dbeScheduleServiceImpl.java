package com.jiangjianan.stock.server.service.impl;

import com.jiangjianan.stock.server.common.service.BaseService;
import com.jiangjianan.stock.server.service.BlogService;
import com.jiangjianan.stock.server.service.ScheduleService;
import com.jiangjianan.stock.server.service.StockAnnouncementService;

public class ScheduleServiceImpl extends BaseService implements ScheduleService {

	private BlogService blogService;
	private StockAnnouncementService stockAnnouncementService;

	public void udpateArticle() {
		blogService.updateAllBlogArticle(false, true);
	}

	public void udpateStockAnnouncement() {
		stockAnnouncementService.updateAllStockAnnouncement();
	}

	public BlogService getBlogService() {
		return blogService;
	}

	public void setBlogService(BlogService blogService) {
		this.blogService = blogService;
	}

	public StockAnnouncementService getStockAnnouncementService() {
		return stockAnnouncementService;
	}

	public void setStockAnnouncementService(
			StockAnnouncementService stockAnnouncementService) {
		this.stockAnnouncementService = stockAnnouncementService;
	}

}
