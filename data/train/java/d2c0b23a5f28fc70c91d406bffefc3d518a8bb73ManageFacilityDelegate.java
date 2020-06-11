package com.skypatrol.delegate;

import java.sql.SQLException;
import java.util.ArrayList;

import com.skypatrol.service.ManageFacilityService;
import com.skypatrol.viewBean.ManageFacilityBean;

public class ManageFacilityDelegate
{
		private ManageFacilityService manageFacilityService;

		public ManageFacilityService getManageFacilityService()
		{
				return this.manageFacilityService;
		}

		public void setManageFacilityService(ManageFacilityService manageFacilityService)
		{
				this.manageFacilityService = manageFacilityService;
		}

		public ArrayList<ManageFacilityBean> getFacilityDetails(ManageFacilityBean manageFacilityBean) {
			return manageFacilityService.getFacilityDetails(manageFacilityBean);
		}

		public boolean deleteFaciity(ManageFacilityBean manageFacilityBean) {
			return manageFacilityService.deleteFaciity(manageFacilityBean);
		}
		
		public ArrayList<ManageFacilityBean> getFacilityList() {
			return manageFacilityService.getFacilityList();
		}

		public ArrayList<ManageFacilityBean> getCheckpointList() {
			return manageFacilityService.getCheckpointList();
		}
		
		public boolean insertFacility(ManageFacilityBean objManageFacilityBean) {
			return manageFacilityService.insertFacility(objManageFacilityBean);
		}
		
		public boolean editFacility(ManageFacilityBean objManageFacilityBean) {
			return manageFacilityService.editFacility(objManageFacilityBean);
		}
}
