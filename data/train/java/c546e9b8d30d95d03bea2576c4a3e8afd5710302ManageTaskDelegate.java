package com.skypatrol.delegate;

import java.sql.SQLException;
import java.util.ArrayList;

import com.skypatrol.service.ManageTaskService;
import com.skypatrol.viewBean.ManageTaskBean;

public class ManageTaskDelegate
{
		private ManageTaskService manageTaskService;

		public ManageTaskService getManageTaskService()
		{
				return this.manageTaskService;
		}

		public void setManageTaskService(ManageTaskService manageTaskService)
		{
				this.manageTaskService = manageTaskService;
		}

		public ArrayList<ManageTaskBean> getTaskDetails(ManageTaskBean manageTaskBean)
		{
		    return manageTaskService.getTaskDetails(manageTaskBean);
		}
		
		public boolean editTaskList(ManageTaskBean manageTaskBean)
		{
		    return manageTaskService.editTaskList(manageTaskBean);
		}
		
		public boolean insertTask(ManageTaskBean objManageTaskBean)
		{
		    return manageTaskService.insertTask(objManageTaskBean);
		}
		
		public ArrayList<ManageTaskBean> getTaskList(ManageTaskBean manageTaskBean)
		{
		    return manageTaskService.getTaskList();
		}
		
		public boolean deleteTask(ManageTaskBean objManageTaskBean) throws SQLException {
			return manageTaskService.deleteTask(objManageTaskBean);
		}
		
}
