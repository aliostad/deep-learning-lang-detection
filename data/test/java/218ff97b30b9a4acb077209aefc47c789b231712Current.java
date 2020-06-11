package com.lee.core.web.mvc;

import com.lee.core.business.repository.CommonRepository;
import com.lee.system.entity.Department;
import com.lee.system.entity.User;
import com.lee.system.repository.DepartmentRepository;
import com.lee.system.repository.UserRepository;


public class Current {
	
	private UserRepository userRepository;
	private DepartmentRepository departmentRepository;
	private CommonRepository commonRepository;
	
	public Current(UserRepository userRepository, DepartmentRepository departmentRepository, CommonRepository commonRepository) {
		this.userRepository = userRepository;
		this.departmentRepository = departmentRepository;
		this.commonRepository = commonRepository;
	}

	/**
	 * 取得当前登录用户
	 */
	public User getUser() {
		return commonRepository.get(User.class,null);
	}
	/**
	 * 取得当前登录用户所属部门（一个）
	 */
	public Department getDepartment() {
		return commonRepository.get(Department.class,null);
	}
}
