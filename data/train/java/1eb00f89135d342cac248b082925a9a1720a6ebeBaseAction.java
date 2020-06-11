package com.student.action;

import com.opensymphony.xwork2.ActionSupport;
import com.student.services.IGradeService;
import com.student.services.IStudentService;
import com.student.services.ITeacherService;
import com.student.services.ITermService;

public class BaseAction extends ActionSupport {
	
	protected IStudentService studentService;
	
	protected IGradeService gradeService;
	
	protected ITermService termService;
	
	public ITeacherService teacherService;
	
	public ITeacherService getTeacherService() {
		return teacherService;
	}
	public void setTeacherService(ITeacherService teacherService) {
		this.teacherService = teacherService;
	}
	
	public void setTermService(ITermService termService) {
		this.termService = termService;
	}

	public void setGradeService(IGradeService gradeService) {
		this.gradeService = gradeService;
	}

	public void setStudentService(IStudentService studentService) {
		this.studentService = studentService;
	}

}
