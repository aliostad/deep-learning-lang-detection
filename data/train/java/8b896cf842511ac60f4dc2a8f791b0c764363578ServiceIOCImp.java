package org.ioc;

import org.eweb4j.ioc.IOC;
import org.service.ArticleService;
import org.service.MarkService;
import org.service.ReplyService;
import org.service.UserService;

public class ServiceIOCImp implements ServiceIOC{

	public UserService createUserService() {
		return IOC.getBean("user_service");
	}

	public ArticleService createArticleService() {
		return IOC.getBean("article_service");
	}

	public MarkService createMarkService() {
		return IOC.getBean("mark_service");
	}
	
	public ReplyService createReplyService(){
		return IOC.getBean("reply_service");
	}
	
}
