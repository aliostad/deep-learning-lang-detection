package com.skypatrol.dao;

import java.util.ArrayList;

import com.skypatrol.viewBean.ManageCheckpointBean;

public interface ManageCheckpointDao
{
		ArrayList<ManageCheckpointBean> getCheckpointDetails(ManageCheckpointBean manageCheckpointBean);

		boolean deleteCheckpoint(ManageCheckpointBean manageCheckpointBean);

		ArrayList<ManageCheckpointBean> getTaskList(ManageCheckpointBean manageCheckpointBean);

		boolean insertCheckpoint(ManageCheckpointBean manageCheckpointBean);

		boolean editCheckpoint(ManageCheckpointBean manageCheckpointBean);
}
