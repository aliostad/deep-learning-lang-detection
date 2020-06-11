package com.mmonit.operatorImpl;

import com.mmonit.Dao.ProcessDao;
import com.mmonit.bean.ProcessBean;
import com.mmonit.operator.ProcessOperator;

public class ProcessOperatorImpl implements ProcessOperator {

	private ProcessDao processDao;
	

	public ProcessDao getProcessDao() {
		return processDao;
	}


	public void setProcessDao(ProcessDao processDao) {
		this.processDao = processDao;
	}


	@Override
	public void saveProcess(ProcessBean processBean, String monitId) {
		
		if(processBean.getMonitId() == null){
			
		}else{
			processDao.saveProcess(processBean,monitId);
		}
			
	} 
	
	

}
