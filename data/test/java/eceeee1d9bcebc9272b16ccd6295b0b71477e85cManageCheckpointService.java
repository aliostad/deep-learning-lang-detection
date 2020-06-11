package com.skypatrol.service;

import java.util.ArrayList;

import com.skypatrol.viewBean.ManageCheckpointBean;
import com.skypatrol.viewBean.ManageTaskBean;

public interface ManageCheckpointService
{
	ArrayList<ManageCheckpointBean> getCheckpointDetails(ManageCheckpointBean manageCheckpointBean);
	
	boolean deleteCheckpoint(ManageCheckpointBean manageCheckpointBean);
	
	ArrayList<ManageCheckpointBean> getTaskList(ManageCheckpointBean manageCheckpointBean);
	
	boolean insertCheckpoint(ManageCheckpointBean manageCheckpointBean);
	
	boolean editCheckpoint(ManageCheckpointBean manageCheckpointBean);
}
