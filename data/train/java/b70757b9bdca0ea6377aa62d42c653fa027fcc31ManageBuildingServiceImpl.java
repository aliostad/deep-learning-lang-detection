package com.skypatrol.service.impl;

import java.sql.SQLException;
import java.util.ArrayList;

import com.skypatrol.dao.ManageBuildingDao;
import com.skypatrol.service.ManageBuildingService;
import com.skypatrol.viewBean.ManageBuildingBean;

public class ManageBuildingServiceImpl implements ManageBuildingService
{

		private ManageBuildingDao manageBuildingDao;

		

		public ManageBuildingDao getManageBuildingDao() {
			return manageBuildingDao;
		}

		public void setManageBuildingDao(ManageBuildingDao manageBuildingDao) {
			this.manageBuildingDao = manageBuildingDao;
		}

		@Override
		public ArrayList<ManageBuildingBean> getBuildingDetails(ManageBuildingBean manageBuildingBean) {
			return manageBuildingDao.getBuildingDetails(manageBuildingBean);
		}

		
}
