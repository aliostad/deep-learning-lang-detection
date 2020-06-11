package scut.labtalk.manager;

import java.io.Serializable;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import scut.labtalk.service.AnswerService;
import scut.labtalk.service.ItemService;
import scut.labtalk.service.QuestionService;
import scut.labtalk.service.UserService;

public class ServiceLocator implements Serializable {

	/**
	 * @author kaibin
	 */
	private static final long serialVersionUID = -6943835759992093655L;
	
	private static ServiceLocator instance = null;
	private UserService userService = null;
	private QuestionService questionService = null;
	private AnswerService answerService = null;
	private ItemService itemService = null;
	
	public ServiceLocator() {
		super();
		ApplicationContext ctx = new ClassPathXmlApplicationContext("applicationContext.xml");
		userService = (UserService) ctx.getBean("userService");
		questionService = (QuestionService) ctx.getBean("questionService");
		itemService = (ItemService) ctx.getBean("itemService");
		answerService = (AnswerService)ctx.getBean("answerService");
	}
	
	public static synchronized ServiceLocator getServiceLocator(){
		if (instance == null) {
			instance = new ServiceLocator();
		}
		return instance;
		
	}
	
	public QuestionService getQuestionService() {
		return questionService;
	}

	public void setQuestionService(QuestionService questionService) {
		this.questionService = questionService;
	}

	public ItemService getItemService() {
		return itemService;
	}

	public void setItemService(ItemService itemService) {
		this.itemService = itemService;
	}

	public UserService getUserService() {
		return userService;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}

	public AnswerService getAnswerService() {
		return answerService;
	}

	public void setAnswerService(AnswerService answerService) {
		this.answerService = answerService;
	}
	

}
