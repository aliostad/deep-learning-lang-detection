package com.zizibujuan.drip.server.servlet;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.zizibujuan.drip.server.service.AccessLogService;
import com.zizibujuan.drip.server.service.ActivityService;
import com.zizibujuan.drip.server.service.AnswerService;
import com.zizibujuan.drip.server.service.ExerciseService;
import com.zizibujuan.drip.server.service.HistExerciseService;


/**
 * 服务容器，所有的服务实例都注入在这里，在servlet中需要引用服务时，统一通过该类调用。
 * FIXME：这是一个折中的方式，本想通过ds的方式为所有servlet添加服务，
 * 可是通过“org.eclipse.equinox.http.registry.servlets”
 * 扩展点方式调用的servlet并不是ds中声明的组件。所以总是报NullPointerException。 
 * 等找到解决方法之后，把这个替换掉。
 * 
 * @author 金正伟
 * @since 0.0.1
 */
public class ServiceHolder {
	private static final Logger logger = LoggerFactory
			.getLogger(ServiceHolder.class);

	private static ServiceHolder singleton;

	public static ServiceHolder getDefault() {
		return singleton;
	}

	public void activate() {
		singleton = this;
	}

	public void deactivate() {
		singleton = null;
	}
	
	private ExerciseService exerciseService;

	public void setExerciseService(ExerciseService exerciseService) {
		logger.info("注入ExerciseService");
		this.exerciseService = exerciseService;
	}

	public void unsetExerciseService(ExerciseService exerciseService) {
		logger.info("注销ExerciseService");
		if (this.exerciseService == exerciseService) {
			this.exerciseService = null;
		}
	}

	public ExerciseService getExerciseService() {
		return this.exerciseService;
	}
	
	private ActivityService activityService;
	public void setActivityService(ActivityService activityService) {
		logger.info("注入ActivityService");
		this.activityService = activityService;
	}

	public void unsetActivityService(ActivityService activityService) {
		logger.info("注销ActivityService");
		if (this.activityService == activityService) {
			this.activityService = null;
		}
	}
	public ActivityService getActivityService() {
		return this.activityService;
	}

	private AccessLogService accessLogService;
	public AccessLogService getAccessLogService() {
		return this.accessLogService;
	}
	public void setAccessLogService(AccessLogService accessLogService) {
		logger.info("注入AccessLogService");
		this.accessLogService = accessLogService;
	}

	public void unsetAccessLogService(AccessLogService accessLogService) {
		logger.info("注销AccessLogService");
		if (this.accessLogService == accessLogService) {
			this.accessLogService = null;
		}
	}



	private AnswerService answerService;
	
	public AnswerService getAnswerService() {
		return answerService;
	}
	public void setAnswerService(AnswerService answerService) {
		logger.info("注入answerService");
		this.answerService = answerService;
	}

	public void unsetAnswerService(AnswerService answerService) {
		logger.info("注销answerService");
		if (this.answerService == answerService) {
			this.answerService = null;
		}
	}

	private HistExerciseService histExerciseService;
	public void setHistExerciseService(HistExerciseService histExerciseService) {
		logger.info("注入histExerciseService");
		this.histExerciseService = histExerciseService;
	}

	public void unsetHistExerciseService(HistExerciseService histExerciseService) {
		logger.info("注销histExerciseService");
		if (this.histExerciseService == histExerciseService) {
			this.histExerciseService = null;
		}
	}
	public HistExerciseService getHistExerciseService() {
		return histExerciseService;
	}
}
