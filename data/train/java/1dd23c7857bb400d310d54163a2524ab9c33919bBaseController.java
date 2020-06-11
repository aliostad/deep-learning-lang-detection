package com.ds.controller;

import javax.annotation.Resource;

import net.sf.json.JSONObject;

import com.ds.service.AccuracyService;
import com.ds.service.AdminService;
import com.ds.service.AnswerService;
import com.ds.service.ClassesService;
import com.ds.service.DisscusionService;
import com.ds.service.LessonService;
import com.ds.service.NewsService;
import com.ds.service.QuestionService;
import com.ds.service.ReplyService;
import com.ds.service.RereplyService;
import com.ds.service.ScoreService;
import com.ds.service.StatusService;
import com.ds.service.StudentService;
import com.ds.service.TeacherService;

public class BaseController {
	
	protected AccuracyService accuracyService;
	protected AdminService adminService;
	protected AnswerService answerService;
	protected ClassesService classesService;
	protected DisscusionService disscusionService;
	protected LessonService lessonService;
	protected NewsService newsService;
	protected QuestionService questionService;
	protected ReplyService replyService;
	protected RereplyService rereplyService;
	protected ScoreService scoreService;
	protected StatusService statusService;
	protected StudentService studentService;
	protected TeacherService teacherService;
	protected JSONObject json = new JSONObject();
	protected String tip;
	
	
	public AccuracyService getAccuracyService() {
		return accuracyService;
	}
	@Resource(name="AccuracyService")
	public void setAccuracyService(AccuracyService accuracyService) {
		this.accuracyService = accuracyService;
	}
	
	
	public AdminService getAdminService() {
		return adminService;
	}
	@Resource(name="AdminService")
	public void setAdminService(AdminService adminService) {
		this.adminService = adminService;
	}
	
	
	public AnswerService getAnswerService() {
		return answerService;
	}
	@Resource(name="AnswerService")
	public void setAnswerService(AnswerService answerService) {
		this.answerService = answerService;
	}
	
	
	public ClassesService getClassesService() {
		return classesService;
	}
	@Resource(name="ClassesService")
	public void setClassesService(ClassesService classesService) {
		this.classesService = classesService;
	}
	
	
	public DisscusionService getDisscusionService() {
		return disscusionService;
	}
	@Resource(name="DisscusionService")
	public void setDisscusionService(DisscusionService disscusionService) {
		this.disscusionService = disscusionService;
	}
	
	
	public LessonService getLessonService() {
		return lessonService;
	}
	@Resource(name="LessonService")
	public void setLessonService(LessonService lessonService) {
		this.lessonService = lessonService;
	}
	
	
	public NewsService getNewsService() {
		return newsService;
	}
	@Resource(name="NewsService")
	public void setNewsService(NewsService newsService) {
		this.newsService = newsService;
	}
	
	
	public QuestionService getQuestionService() {
		return questionService;
	}
	@Resource(name="QuestionService")
	public void setQuestionService(QuestionService questionService) {
		this.questionService = questionService;
	}
	
	
	public ReplyService getReplyService() {
		return replyService;
	}
	@Resource(name="ReplyService")
	public void setReplyService(ReplyService replyService) {
		this.replyService = replyService;
	}
	
	
	public RereplyService getRereplyService() {
		return rereplyService;
	}
	@Resource(name="RereplyService")
	public void setRereplyService(RereplyService rereplyService) {
		this.rereplyService = rereplyService;
	}
	
	
	public ScoreService getScoreService() {
		return scoreService;
	}
	@Resource(name="ScoreService")
	public void setScoreService(ScoreService scoreService) {
		this.scoreService = scoreService;
	}
	
	
	public StatusService getStatusService() {
		return statusService;
	}
	@Resource(name="StatusService")
	public void setStatusService(StatusService statusService) {
		this.statusService = statusService;
	}
	
	
	public StudentService getStudentService() {
		return studentService;
	}
	@Resource(name="StudentService")
	public void setStudentService(StudentService studentService) {
		this.studentService = studentService;
	}
	
	
	public TeacherService getTeacherService() {
		return teacherService;
	}
	@Resource(name="TeacherService")
	public void setTeacherService(TeacherService teacherService) {
		this.teacherService = teacherService;
	}
	
	public JSONObject getJson() {
		return json;
	}
	public void setJson(JSONObject json) {
		this.json = json;
	}
	
	public String getTip() {
		return tip;
	}
	public void setTip(String tip) {
		this.tip = tip;
	}

	
}
