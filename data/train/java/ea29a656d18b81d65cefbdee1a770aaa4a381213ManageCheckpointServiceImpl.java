package com.skypatrol.service.impl;

import java.util.ArrayList;

import com.skypatrol.dao.ManageCheckpointDao;
import com.skypatrol.service.ManageCheckpointService;
import com.skypatrol.viewBean.ManageCheckpointBean;

public class ManageCheckpointServiceImpl implements ManageCheckpointService
{

		private ManageCheckpointDao manageCheckpointDao;

		public ManageCheckpointDao getManageAgentDao()
		{
				return this.manageCheckpointDao;
		}

		public void setManageCheckpointDao(ManageCheckpointDao manageCheckpointDao)
		{
				this.manageCheckpointDao = manageCheckpointDao;
		}

		@Override
		public ArrayList<ManageCheckpointBean> getCheckpointDetails(ManageCheckpointBean manageCheckpointBean) {
			return manageCheckpointDao.getCheckpointDetails(manageCheckpointBean);
		}

		@Override
		public boolean deleteCheckpoint(ManageCheckpointBean manageCheckpointBean) {
			return manageCheckpointDao.deleteCheckpoint(manageCheckpointBean);
		}

		@Override
		public ArrayList<ManageCheckpointBean> getTaskList(ManageCheckpointBean manageCheckpointBean) {
			return manageCheckpointDao.getTaskList(manageCheckpointBean);
		}

		@Override
		public boolean insertCheckpoint(ManageCheckpointBean manageCheckpointBean) {
			return manageCheckpointDao.insertCheckpoint(manageCheckpointBean);			
		}

		@Override
		public boolean editCheckpoint(ManageCheckpointBean manageCheckpointBean) {
			// TODO Auto-generated method stub
			return manageCheckpointDao.editCheckpoint(manageCheckpointBean);
		}

}
