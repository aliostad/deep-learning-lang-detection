package com.skypatrol.delegate;


import java.util.ArrayList;

import com.skypatrol.service.ManageCheckpointService;
import com.skypatrol.viewBean.ManageCheckpointBean;
import com.skypatrol.viewBean.ManageTaskBean;

public class ManageCheckpointDelegate
{
		private ManageCheckpointService manageCheckpointService;

		public ManageCheckpointService getManageCheckpointService()
		{
				return this.manageCheckpointService;
		}

		public void setManageCheckpointService(ManageCheckpointService manageCheckpointService)
		{
				this.manageCheckpointService = manageCheckpointService;
		}
		
		public ArrayList<ManageCheckpointBean> getTaskDetails(ManageCheckpointBean manageCheckpointBean) {
			return manageCheckpointService.getCheckpointDetails(manageCheckpointBean);
		}
		
		public boolean deleteCheckpoint(ManageCheckpointBean manageCheckpointBean) {
			return manageCheckpointService.deleteCheckpoint(manageCheckpointBean);
		}
		
		public ArrayList<ManageCheckpointBean> getTaskList(ManageCheckpointBean manageCheckpointBean) {
			return manageCheckpointService.getTaskList(manageCheckpointBean);
		}
		
		public boolean insertCheckpoint(ManageCheckpointBean manageCheckpointBean) {
			return manageCheckpointService.insertCheckpoint(manageCheckpointBean);			
		}
	
		public boolean editCheckpoint(ManageCheckpointBean manageCheckpointBean) {
			return manageCheckpointService.editCheckpoint(manageCheckpointBean);
		}
}
