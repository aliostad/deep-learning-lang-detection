package com.efforts.common.data;

import javax.naming.NamingException;

import com.efforts.service.action.EffortsServiceBeanLocal;
import com.efforts.service.action.ManagerInfoServiceBeanLocal;
import com.efforts.service.action.ProjectInfoServiceBeanLocal;
import com.efforts.service.login.UserServiceBeanLocal;
import com.efforts.service.util.EffortsServiceConstants;
import com.efforts.utilities.EffortsServiceLocator;

public class CommonInfo {

	private UserServiceBeanLocal userService;
	private ProjectInfoServiceBeanLocal projectService;
	private ManagerInfoServiceBeanLocal managerService;
	private EffortsServiceBeanLocal effortService;

	public UserServiceBeanLocal getUserService() {
		try {
			userService = (UserServiceBeanLocal) EffortsServiceLocator
					.getLocalHome(EffortsServiceConstants.UserServiceConstant);

		} catch (NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return userService;
	}

	public void setProjectService(ProjectInfoServiceBeanLocal projectService) {
		this.projectService = projectService;
	}

	public ManagerInfoServiceBeanLocal getManagerService() {
		try {
			managerService = (ManagerInfoServiceBeanLocal) EffortsServiceLocator
					.getLocalHome(EffortsServiceConstants.ManagerServiceConstant);
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return managerService;
	}

	public void setManagerService(ManagerInfoServiceBeanLocal managerService) {
		this.managerService = managerService;
	}

	public void setUserService(UserServiceBeanLocal userService) {
		this.userService = userService;
	}

	public ProjectInfoServiceBeanLocal getProjectService() {
		try {
			projectService = (ProjectInfoServiceBeanLocal) EffortsServiceLocator
					.getLocalHome(EffortsServiceConstants.ProjectServiceConstant);
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return projectService;
	}

	public EffortsServiceBeanLocal getEffortService() {
		try {
			effortService = (EffortsServiceBeanLocal) EffortsServiceLocator
					.getLocalHome(EffortsServiceConstants.EffortsServiceConstant);
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return effortService;
	}

	public void setEffortService(EffortsServiceBeanLocal effortService) {
		this.effortService = effortService;
	}

}
