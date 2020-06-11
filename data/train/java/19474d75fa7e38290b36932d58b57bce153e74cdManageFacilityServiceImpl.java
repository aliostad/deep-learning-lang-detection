package com.skypatrol.service.impl;

import java.sql.SQLException;
import java.util.ArrayList;

import com.skypatrol.dao.ManageFacilityDao;
import com.skypatrol.service.ManageFacilityService;
import com.skypatrol.viewBean.ManageFacilityBean;

public class ManageFacilityServiceImpl implements ManageFacilityService
{

		private ManageFacilityDao manageFacilityDao;

		public ManageFacilityDao getManageAgentDao()
		{
				return this.manageFacilityDao;
		}

		public void setManageFacilityDao(ManageFacilityDao manageFacilityDao)
		{
				this.manageFacilityDao = manageFacilityDao;
		}

		@Override
		public ArrayList<ManageFacilityBean> getFacilityDetails(ManageFacilityBean manageFacilityBean) {
			return manageFacilityDao.getFacilityDetails(manageFacilityBean);
		}

		@Override
		public boolean deleteFaciity(ManageFacilityBean manageFacilityBean) {
			return manageFacilityDao.deleteFaciity(manageFacilityBean);
		}

		@Override
		public ArrayList<ManageFacilityBean> getFacilityList() {
			return manageFacilityDao.getFacilityList();
		}

		@Override
		public ArrayList<ManageFacilityBean> getCheckpointList() {
			return manageFacilityDao.getCheckpointList();
		}

		@Override
		public boolean insertFacility(ManageFacilityBean objManageFacilityBean) {
			return manageFacilityDao.insertFacility(objManageFacilityBean);
		}

		@Override
		public boolean editFacility(ManageFacilityBean objManageFacilityBean) {
			return manageFacilityDao.editFacility(objManageFacilityBean);
		}

}
