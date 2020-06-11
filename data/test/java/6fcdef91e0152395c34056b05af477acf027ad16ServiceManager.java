package com.sun.app.service;

import com.sun.app.service.admin.AboutService;
import com.sun.app.service.admin.AdminProjectService;
import com.sun.app.service.admin.ContactService;
import com.sun.app.service.admin.CultureService;
import com.sun.app.service.admin.EventService;
import com.sun.app.service.admin.GroupService;
import com.sun.app.service.admin.HonourService;
import com.sun.app.service.admin.LinkService;
import com.sun.app.service.admin.NewsService;
import com.sun.app.service.admin.SysService;
import com.sun.app.service.admin.TypeService;
import com.sun.app.service.admin.UserService;
import com.sun.app.service.admin.ZhaopinService;

/**
 * @author LH
 * 
 */
public class ServiceManager {
	private UserService userService;
	private GroupService groupService;
	private NewsService newsService;
	private EventService eventService;
	private AdminProjectService adminProjectService;
	private CultureService cultureService;
	private ZhaopinService zhaopinService;
	private HonourService honourService;
	private TypeService typeService;
	private ContactService contactService;
	private AboutService aboutService;
	private LinkService linkService;
	private SysService sysService;
	
	
	
	
	
	

	public SysService getSysService() {
		return sysService;
	}

	public void setSysService(SysService sysService) {
		this.sysService = sysService;
	}

	public LinkService getLinkService() {
		return linkService;
	}

	public void setLinkService(LinkService linkService) {
		this.linkService = linkService;
	}

	public AboutService getAboutService() {
		return aboutService;
	}

	public void setAboutService(AboutService aboutService) {
		this.aboutService = aboutService;
	}

	public ContactService getContactService() {
		return contactService;
	}

	public void setContactService(ContactService contactService) {
		this.contactService = contactService;
	}

	public TypeService getTypeService() {
		return typeService;
	}

	public void setTypeService(TypeService typeService) {
		this.typeService = typeService;
	}

	public HonourService getHonourService() {
		return honourService;
	}

	public void setHonourService(HonourService honourService) {
		this.honourService = honourService;
	}

	public ZhaopinService getZhaopinService() {
		return zhaopinService;
	}

	public void setZhaopinService(ZhaopinService zhaopinService) {
		this.zhaopinService = zhaopinService;
	}

	public CultureService getCultureService() {
		return cultureService;
	}

	public void setCultureService(CultureService cultureService) {
		this.cultureService = cultureService;
	}

	public AdminProjectService getAdminProjectService() {
		return adminProjectService;
	}

	public void setAdminProjectService(AdminProjectService adminProjectService) {
		this.adminProjectService = adminProjectService;
	}

	public EventService getEventService() {
		return eventService;
	}

	public void setEventService(EventService eventService) {
		this.eventService = eventService;
	}

	public NewsService getNewsService() {
		return newsService;
	}

	public void setNewsService(NewsService newsService) {
		this.newsService = newsService;
	}

	public GroupService getGroupService() {
		return groupService;
	}

	public void setGroupService(GroupService groupService) {
		this.groupService = groupService;
	}

	public UserService getUserService() {
		return userService;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}

}
