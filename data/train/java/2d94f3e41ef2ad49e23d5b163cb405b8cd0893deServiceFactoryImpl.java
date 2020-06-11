package ua.net.forum.serviceImpl;

import ua.net.forum.service.IForbiddenWordService;
import ua.net.forum.service.IMessageService;
import ua.net.forum.service.IProfileService;
import ua.net.forum.service.IRoleService;
import ua.net.forum.service.ISectionService;
import ua.net.forum.service.ITopicService;
import ua.net.forum.service.IUserService;
import ua.net.forum.service.ServiceFactory;

/**
 * Реализация фабрики серсисов
 *
 * @author Prepodi
 */
public class ServiceFactoryImpl extends ServiceFactory {

	@Override
	public ISectionService getSectionService() {
		return new SectionServiceImpl();
	}

	@Override
	public ITopicService getTopicService() {
		return new TopicServiceImpl();
	}

	@Override
	public IMessageService getMessageService() {
		return new MessageServiceImpl();
	}

	@Override
	public IProfileService getProfileService() {
		return new ProfileServiceImpl();
	}

	@Override
	public IUserService getUserService() {
		return new UserServiceImpl();
	}

	@Override
	public IRoleService getRoleService() {
		return new RoleServiceImpl();
	}

	@Override
	public IForbiddenWordService getForbiddenWordService() {
		return new ForbiddenWordServiceImpl();
	}

}
