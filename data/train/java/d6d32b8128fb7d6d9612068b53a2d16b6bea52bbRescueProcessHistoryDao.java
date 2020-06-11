package com.fix.obd.web.dao;

import java.util.List;

import com.fix.obd.web.model.RescueProcessHistory;

public interface RescueProcessHistoryDao {
	public List<RescueProcessHistory> getAllRescueProcessHistory();

	public void addRescueProcessHistory(RescueProcessHistory rescueProcessHistory);

	public void removeAllRescueProcessHistory();

	public void deleteRescueProcessHistory(RescueProcessHistory rescueProcessHistory);

	public void updateRescueProcessHistory(RescueProcessHistory rescueProcessHistory);

	public List<RescueProcessHistory> findByHQL(String hql) throws Exception;
}
