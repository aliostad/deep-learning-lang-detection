/**
 * @(#)ManageCourseController.java     	2013-10-9 下午3:48:34
 * Copyright never.All rights reserved
 * never PROPRIETARY/CONFIDENTIAL. Use is subject to license terms.
 */
package com.example.cssnwu.businesslogic.controller;

import java.rmi.RemoteException;
import java.util.ArrayList;

import com.example.cssnwu.businesslogic.domain.ManageCourse;
import com.example.cssnwu.businesslogicservice.bl.ManageCourseBLService;
import com.example.cssnwu.businesslogicservice.resultenum.ADD_RESULT;
import com.example.cssnwu.businesslogicservice.resultenum.DELETE_RESULT;
import com.example.cssnwu.businesslogicservice.resultenum.MANAGE_RESULT;
import com.example.cssnwu.businesslogicservice.resultenum.ManageCourseType;
import com.example.cssnwu.businesslogicservice.resultenum.SYSTEM_STATE;
import com.example.cssnwu.vo.CourseVO;
import com.example.cssnwu.vo.ManageCourseVO;

/**
 *Class <code>ManageCourseController.java</code> 管理课程的控制器
 *
 * @author never
 * @version 2013-10-9
 * @since JDK1.7
 */
public class ManageCourseController implements ManageCourseBLService{
    public ManageCourse manageCourse;
    
    
	public ManageCourseController() throws RemoteException {
		manageCourse = new ManageCourse();
	}
	
	/* (non-Javadoc)
	 * Title: getSelectedCourses
	 * Description:通过id获取该学生已经选择的课程列表
	 * @see com.example.cssnwu.businesslogicservice.bl.ManageCourseBLService#getSelectedCourses(int)
	 */
	@Override
	public ArrayList<CourseVO> getSelectedCourses(int studentId) throws RemoteException {
		return manageCourse.getSelectedCourses(studentId);
	}

	/* (non-Javadoc)
	 * Title: addStudent
	 * Description:   开始管理课程时，添加执行该操作的学生
	 * @see com.example.cssnwu.businesslogicservice.bl.ManageCourseBLService#addStudent(com.example.cssnwu.vo.StudentVO)
	 */
	@Override
	public ADD_RESULT addStudent(int studentId) throws RemoteException {
		return manageCourse.addStudent(studentId);
	}

	/* (non-Javadoc)
	 * Title: addManageType
	 * Description:开始管理课程时，添加管理课程操作的类型
	 * @see com.example.cssnwu.businesslogicservice.bl.ManageCourseBLService#addManageType(com.example.cssnwu.businesslogicservice.resultenum.ManageCourseType)
	 */
	@Override
	public ADD_RESULT addManageType(ManageCourseType manageCourseType) {
		return manageCourse.addManageType(manageCourseType);
	}

	/* (non-Javadoc)
	 * Title: addCourse
	 * Description:在进行课程管理时，往将要被管理的课程列表中添加课程
	 * @see com.example.cssnwu.businesslogicservice.bl.ManageCourseBLService#addCourse(com.example.cssnwu.vo.CourseVO)
	 */
	@Override
	public ADD_RESULT addCourse(CourseVO courseVO) {
		return manageCourse.addCourse(courseVO);
	}

	/* (non-Javadoc)
	 * Title: deleteCourse
	 * Description:在进行课程管理时，从将要管理的课程列表中删除课程
	 * @see com.example.cssnwu.businesslogicservice.bl.ManageCourseBLService#deleteCourse(com.example.cssnwu.vo.CourseVO)
	 */
	@Override
	public DELETE_RESULT deleteCourse(CourseVO courseVO) {
		return manageCourse.deleteCourse(courseVO);
	}

	/* (non-Javadoc)
	 * Title: endManage
	 * Description: 结束课程管理操作，将请求提交服务器
	 * @see com.example.cssnwu.businesslogicservice.bl.ManageCourseBLService#endManage(com.example.cssnwu.vo.ManageCourseVO)
	 */
	@Override
	public MANAGE_RESULT endManage() throws RemoteException {
		return manageCourse.endManage();
	}

	

}
