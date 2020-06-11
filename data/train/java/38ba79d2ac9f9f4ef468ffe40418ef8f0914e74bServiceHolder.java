package com.zizibujuan.teach.server.servlets;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.zizibujuan.teach.server.service.ClassService;
import com.zizibujuan.teach.server.service.CourseService;
import com.zizibujuan.teach.server.service.CurriculumService;
import com.zizibujuan.teach.server.service.LessonService;
import com.zizibujuan.teach.server.service.PPTService;


/**
 * 服务对象容器
 * 
 * @author jzw
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
	
	private CourseService courseService;

	public void setCourseService(CourseService courseService) {
		logger.info("注入CourseService");
		this.courseService = courseService;
	}

	public void unsetCourseService(CourseService courseService) {
		logger.info("注销CourseService");
		if (this.courseService == courseService) {
			this.courseService = null;
		}
	}
	public CourseService getCourseService() {
		return this.courseService;
	}

	private LessonService lessonService;

	public void setLessonService(LessonService lessonService) {
		logger.info("注入LessonService");
		this.lessonService = lessonService;
	}

	public void unsetLessonService(LessonService lessonService) {
		logger.info("注销LessonService");
		if (this.lessonService == lessonService) {
			this.lessonService = null;
		}
	}
	
	public LessonService getLessonService() {
		return lessonService;
	}

	
	private PPTService pptService;

	public void setPPTService(PPTService pptService) {
		logger.info("注入PPTService");
		this.pptService = pptService;
	}

	public void unsetPPTService(PPTService pptService) {
		logger.info("注销PPTService");
		if (this.pptService == pptService) {
			this.pptService = null;
		}
	}
	public PPTService getPPTService() {
		return pptService;
	}

	
	private ClassService classService;

	public void setClassService(ClassService classService) {
		logger.info("注入ClassService");
		this.classService = classService;
	}

	public void unsetClassService(ClassService classService) {
		logger.info("注销ClassService");
		if (this.classService == classService) {
			this.classService = null;
		}
	}
	public ClassService getClassService() {
		return classService;
	}

	private CurriculumService curriculumService;

	public void setCurriculumService(CurriculumService curriculumService) {
		logger.info("注入CurriculumService");
		this.curriculumService = curriculumService;
	}

	public void unsetCurriculumService(CurriculumService curriculumService) {
		logger.info("注销CurriculumService");
		if (this.curriculumService == curriculumService) {
			this.curriculumService = null;
		}
	}
	public CurriculumService getCurriculumService() {
		return curriculumService;
	}
}
