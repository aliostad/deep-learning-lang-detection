package ula.common;

import ula.quartz.service.SendResourceService;
import ula.service.admin.AboutService;
import ula.service.admin.ArticleService;
import ula.service.admin.CityServcie;
import ula.service.admin.ContactService;
import ula.service.admin.ExchangeService;
import ula.service.admin.FeedbackService;
import ula.service.admin.HotelService;
import ula.service.admin.LinkService;
import ula.service.admin.LogService;
import ula.service.admin.PicService;
import ula.service.admin.ProductService;
import ula.service.admin.RecommendService;
import ula.service.admin.ReservationService;
import ula.service.admin.ResourceService;
import ula.service.admin.SpecialService;
import ula.service.admin.SubscriberService;
import ula.service.admin.TourService;
import ula.service.admin.UserService;
import ula.service.admin.WeatherService;
import ula.service.front.FrontService;
import ula.service.front.IndexService;

/**
 * Service管理器
 * 
 * @author Nanlei
 * 
 */
public class ServiceManager {

	private LogService logService;
	private AboutService aboutService;
	private ContactService contactService;
	private CityServcie cityServcie;
	private SpecialService specialService;
	private LinkService linkService;
	private PicService picService;
	private UserService userService;
	private ArticleService articleService;
	private FeedbackService feedbackService;
	private ReservationService reservationService;
	private HotelService hotelService;

	private RecommendService recommendService;
	private WeatherService weatherService;
	private ResourceService resourceService;
	private SendResourceService sendResourceService;
	private SubscriberService subscriberService;
	private TourService tourService;
	private ProductService productService;
	private ExchangeService exchangeService;
	// 前台
	private IndexService indexService;
	private FrontService frontService;

	public ReservationService getReservationService() {
		return reservationService;
	}

	public void setReservationService(ReservationService reservationService) {
		this.reservationService = reservationService;
	}

	public FeedbackService getFeedbackService() {
		return feedbackService;
	}

	public void setFeedbackService(FeedbackService feedbackService) {
		this.feedbackService = feedbackService;
	}

	public LinkService getLinkService() {
		return linkService;
	}

	public void setLinkService(LinkService linkService) {
		this.linkService = linkService;
	}

	public SpecialService getSpecialService() {
		return specialService;
	}

	public void setSpecialService(SpecialService specialService) {
		this.specialService = specialService;
	}

	public CityServcie getCityServcie() {
		return cityServcie;
	}

	public void setCityServcie(CityServcie cityServcie) {
		this.cityServcie = cityServcie;
	}

	public ContactService getContactService() {
		return contactService;
	}

	public void setContactService(ContactService contactService) {
		this.contactService = contactService;
	}

	public AboutService getAboutService() {
		return aboutService;
	}

	public void setAboutService(AboutService aboutService) {
		this.aboutService = aboutService;
	}

	public LogService getLogService() {
		return logService;
	}

	public void setLogService(LogService logService) {
		this.logService = logService;
	}

	public PicService getPicService() {
		return picService;
	}

	public void setPicService(PicService picService) {
		this.picService = picService;
	}

	public UserService getUserService() {
		return userService;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}

	public ArticleService getArticleService() {
		return articleService;
	}

	public void setArticleService(ArticleService articleService) {
		this.articleService = articleService;
	}

	public HotelService getHotelService() {
		return hotelService;
	}

	public void setHotelService(HotelService hotelService) {
		this.hotelService = hotelService;
	}

	public RecommendService getRecommendService() {
		return recommendService;
	}

	public void setRecommendService(RecommendService recommendService) {
		this.recommendService = recommendService;
	}

	public WeatherService getWeatherService() {
		return weatherService;
	}

	public void setWeatherService(WeatherService weatherService) {
		this.weatherService = weatherService;
	}

	public ResourceService getResourceService() {
		return resourceService;
	}

	public void setResourceService(ResourceService resourceService) {
		this.resourceService = resourceService;
	}

	public SubscriberService getSubscriberService() {
		return subscriberService;
	}

	public void setSubscriberService(SubscriberService subscriberService) {
		this.subscriberService = subscriberService;
	}

	public TourService getTourService() {
		return tourService;
	}

	public void setTourService(TourService tourService) {
		this.tourService = tourService;
	}

	public ProductService getProductService() {
		return productService;
	}

	public void setProductService(ProductService productService) {
		this.productService = productService;
	}

	public ExchangeService getExchangeService() {
		return exchangeService;
	}

	public void setExchangeService(ExchangeService exchangeService) {
		this.exchangeService = exchangeService;
	}

	// 前台

	public IndexService getIndexService() {
		return indexService;
	}

	public void setIndexService(IndexService indexService) {
		this.indexService = indexService;
	}

	public FrontService getFrontService() {
		return frontService;
	}

	public void setFrontService(FrontService frontService) {
		this.frontService = frontService;
	}

    public SendResourceService getSendResourceService() {
        return sendResourceService;
    }

    public void setSendResourceService(SendResourceService sendResourceService) {
        this.sendResourceService = sendResourceService;
    }
	
	
	

}
