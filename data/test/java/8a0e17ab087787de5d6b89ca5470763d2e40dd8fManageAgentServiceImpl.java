package com.skypatrol.service.impl;

import java.sql.SQLException;
import java.util.ArrayList;

import com.skypatrol.dao.ManageAgentDao;
import com.skypatrol.service.ManageAgentService;
import com.skypatrol.viewBean.ManageAgentBean;

public class ManageAgentServiceImpl implements ManageAgentService
{

		private ManageAgentDao manageAgentDao;

		public ManageAgentDao getManageAgentDao()
		{
				return this.manageAgentDao;
		}

		public void setManageAgentDao(ManageAgentDao manageAgentDao)
		{
				this.manageAgentDao = manageAgentDao;
		}

		@Override
		public ArrayList<ManageAgentBean> getAgentDetails(ManageAgentBean manageAgentBean) {
			return manageAgentDao.getAgentDetails(manageAgentBean);
		}

		@Override
		public ArrayList<ManageAgentBean> getAgentList() {
			return manageAgentDao.getAgentList();
		}

		@Override
		public ArrayList<ManageAgentBean> getFacilityId() {
			return manageAgentDao.getFacilityId();
		}

		@Override
		public boolean mapAgent(ManageAgentBean manageAgentBean) {
			return manageAgentDao.mapAgent(manageAgentBean);
		}

		@Override
		public boolean insertAgent(ManageAgentBean objManageAgentBean) {
			return manageAgentDao.insertAgent(objManageAgentBean);
		}
}
