package com.mmonit.DaoImpl;

import org.springframework.jdbc.core.JdbcTemplate;

import com.mmonit.Dao.ProcessDao;
import com.mmonit.bean.ProcessBean;

public class ProcessDaoImpl implements ProcessDao {

	private JdbcTemplate jt;
	
	
	
	public JdbcTemplate getJt() {
		return jt;
	}

	public void setJt(JdbcTemplate jt) {
		this.jt = jt;
	}

	@Override
	public void saveProcess(ProcessBean processBean,String monitId) {
		String sql = "insert into process(processName,processStatus,collected_sec,collected_usec,processPid,"
				+ "processUptime,processChildren,processMemPercenttotal,processMemKilobytetotal,"
				+ "processCpuPercenttotal,monitId) values(?,?,?,?,?,?,?,?,?,?,?)";
		jt.update(sql,processBean.getProcessName(),processBean.getProcessStatus(),processBean.getCollected_sec(),processBean.getCollected_usec(),
				processBean.getProcessPid(),processBean.getProcessUptime(),processBean.getProcessChildren(),
				processBean.getProcessMemPercenttotal(),processBean.getProcessMemKilobytetotal(),
				processBean.getProcessCpuPercenttotal(),monitId);
		
	}

}
