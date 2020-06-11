package com.skypatrol.delegate;

import java.sql.SQLException;
import java.util.ArrayList;

import com.skypatrol.service.ManageAgentService;
import com.skypatrol.viewBean.ManageAgentBean;

public class ManageAgentDelegate
{
		private ManageAgentService manageAgentService;

		public ManageAgentService getManageAgentService()
		{
				return this.manageAgentService;
		}

		public void setManageAgentService(ManageAgentService manageAgentService)
		{
				this.manageAgentService = manageAgentService;
		}

		public ArrayList<ManageAgentBean> getAgentDetails(ManageAgentBean manageAgentBean) {
			return manageAgentService.getAgentDetails(manageAgentBean);
		}
		
		public ArrayList<ManageAgentBean> getAgentList() {
			return manageAgentService.getAgentList();
		}

		public ArrayList<ManageAgentBean> getFacilityId() {
			return manageAgentService.getFacilityId();
		}
		
		public boolean mapAgent(ManageAgentBean manageAgentBean) {
			return manageAgentService.mapAgent(manageAgentBean);
		}
		
		public boolean insertAgent(ManageAgentBean objManageAgentBean) {
			return manageAgentService.insertAgent(objManageAgentBean);
		}
}
