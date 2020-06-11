package com.skypatrol.service.impl;

import java.sql.SQLException;
import java.util.ArrayList;

import com.skypatrol.dao.ManageTaskDao;
import com.skypatrol.service.ManageTaskService;
import com.skypatrol.viewBean.ManageTaskBean;

public class ManageTaskServiceImpl implements ManageTaskService
{

		private ManageTaskDao manageTaskDao;

		public ManageTaskDao getManageAgentDao()
		{
				return this.manageTaskDao;
		}

		public void setManageTaskDao(ManageTaskDao manageTaskDao)
		{
				this.manageTaskDao = manageTaskDao;
		}

		@Override
		public ArrayList<ManageTaskBean> getTaskDetails(ManageTaskBean manageTaskBean) 
		{
				return manageTaskDao.getTaskDetails(manageTaskBean);
		}
		
		@Override
		public boolean editTaskList(ManageTaskBean manageTaskBean) 
		{
				return manageTaskDao.editTaskList(manageTaskBean);
		}
		
		@Override
		public boolean insertTask(ManageTaskBean objManageTaskBean) 
		{
				return manageTaskDao.insertTask(objManageTaskBean);
		}

		@Override
		public ArrayList<ManageTaskBean> getTaskList()  {
			return manageTaskDao.getTaskList();
		}

		@Override
		public boolean deleteTask(ManageTaskBean objManageTaskBean)  {
			return manageTaskDao.deleteTask(objManageTaskBean);
		}

}
