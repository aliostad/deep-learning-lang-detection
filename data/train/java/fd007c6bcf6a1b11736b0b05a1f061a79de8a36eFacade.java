package ssh.demo.facade;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import ssh.demo.service.ConfigService;
import ssh.demo.service.DepartmentService;
import ssh.demo.service.GroupService;
import ssh.demo.service.LinkService;
import ssh.demo.service.LogService;
import ssh.demo.service.NewsService;
import ssh.demo.service.NewsAttachmentService;
import ssh.demo.service.ResourceService;
import ssh.demo.service.TypeService;
import ssh.demo.service.UserService;

/**
 * Facade 模式，集中了所有的 Service
 * 
 * @author jinqinghua@gmail.com
 * @version 2013-12-23 03:32:42
 */
@Component
public class Facade {

	@Autowired
	private ConfigService configService;

	@Autowired
	private DepartmentService departmentService;

	@Autowired
	private GroupService groupService;

	@Autowired
	private LinkService linkService;

	@Autowired
	private LogService logService;

	@Autowired
	private NewsService newsService;

	@Autowired
	private NewsAttachmentService newsAttachmentService;

	@Autowired
	private ResourceService resourceService;

	@Autowired
	private TypeService typeService;

	@Autowired
	private UserService userService;

	public Facade() {

	}

	public ConfigService getConfigService() {
		return configService;
	}

	public void setConfigService(ConfigService configService) {
		this.configService = configService;
	}

	public DepartmentService getDepartmentService() {
		return departmentService;
	}

	public void setDepartmentService(DepartmentService departmentService) {
		this.departmentService = departmentService;
	}

	public GroupService getGroupService() {
		return groupService;
	}

	public void setGroupService(GroupService groupService) {
		this.groupService = groupService;
	}

	public LinkService getLinkService() {
		return linkService;
	}

	public void setLinkService(LinkService linkService) {
		this.linkService = linkService;
	}

	public LogService getLogService() {
		return logService;
	}

	public void setLogService(LogService logService) {
		this.logService = logService;
	}

	public NewsService getNewsService() {
		return newsService;
	}

	public void setNewsService(NewsService newsService) {
		this.newsService = newsService;
	}

	public NewsAttachmentService getNewsAttachmentService() {
		return newsAttachmentService;
	}

	public void setNewsAttachmentService(NewsAttachmentService newsAttachmentService) {
		this.newsAttachmentService = newsAttachmentService;
	}

	public ResourceService getResourceService() {
		return resourceService;
	}

	public void setResourceService(ResourceService resourceService) {
		this.resourceService = resourceService;
	}

	public TypeService getTypeService() {
		return typeService;
	}

	public void setTypeService(TypeService typeService) {
		this.typeService = typeService;
	}

	public UserService getUserService() {
		return userService;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}

}
