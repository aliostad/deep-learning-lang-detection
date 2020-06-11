package ula.common;

import ula.service.admin.AboutService;
import ula.service.admin.ArticleService;
import ula.service.admin.CityServcie;
import ula.service.admin.ContactService;
import ula.service.admin.FeedbackService;
import ula.service.admin.HotelService;
import ula.service.admin.LinkService;
import ula.service.admin.LogService;
import ula.service.admin.PaymentService;
import ula.service.admin.PicService;
import ula.service.admin.ProgramService;
import ula.service.admin.ReservationService;
import ula.service.admin.SpecialService;
import ula.service.admin.UserService;

public class ServiceManager {

	/*
	 * 这里是所有Service的集合。并提供Getter 和 Setter
	 */

	private LogService logService = null;
	private AboutService aboutService = null;
	private ContactService contactService = null;
	private CityServcie cityServcie = null;
	private ProgramService programService = null;
	private PaymentService paymentService = null;
	private SpecialService specialService = null;
	private LinkService linkService = null;
	private PicService picService = null;
	private UserService userService = null;
	private ArticleService articleService = null;
	private FeedbackService feedbackService = null;
	private ReservationService reservationService = null;
	private HotelService hotelService = null;

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

	public PaymentService getPaymentService() {
		return paymentService;
	}

	public void setPaymentService(PaymentService paymentService) {
		this.paymentService = paymentService;
	}

	public ProgramService getProgramService() {
		return programService;
	}

	public void setProgramService(ProgramService programService) {
		this.programService = programService;
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

}
