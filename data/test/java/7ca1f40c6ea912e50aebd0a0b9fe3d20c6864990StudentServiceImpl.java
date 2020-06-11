package com.xininit.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xininit.dao.AccountManageDAOI;
import com.xininit.dao.StudentDAOI;
import com.xininit.pojo.AccountManage;
import com.xininit.pojo.Student;
import com.xininit.service.StudentServiceI;

/**
 * 
 * @author xin
 * @version 1.0(xin) 2015年2月24日 上午12:39:53
 */
@Service("studentService")
public class StudentServiceImpl implements StudentServiceI{

	@Autowired
	private StudentDAOI studentDAO;
	@Autowired
	private AccountManageDAOI accountManageDAO;
	
	@Override
	public Integer addNewStudent(Student student) {
		//student没有维持关系的权限，必须先创建AccountManage
		AccountManage accountManage = student.getAccountManage();
		this.accountManageDAO.save(accountManage);
		
		/*
		保存方法一:update(accountManage)
		accountManage.setStudent(student);
		accountManageDAO.update(accountManage);
		return accountManage.getStudent().getId();
		*/
		//保存方法二:既然accountManage已经创建了，那直接save就可以了
		return (Integer) this.studentDAO.save(student);
	}

}
