package ua.net.forum.service;

import ua.net.forum.serviceImpl.ServiceFactoryImpl;

public abstract class ServiceFactory {

    public static final ServiceFactory DEFAULT = new ServiceFactoryImpl();

    public abstract ISectionService getSectionService();
    public abstract ITopicService getTopicService();
    public abstract IMessageService getMessageService();
    public abstract IProfileService getProfileService();
    public abstract IUserService getUserService();
    public abstract IRoleService getRoleService();
    public abstract IForbiddenWordService getForbiddenWordService();
}
