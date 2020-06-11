package com.pearl.normandy.processstep;

import java.util.List;
import org.apache.log4j.Logger;
import org.springframework.transaction.annotation.Transactional;


public class ProcessStepService {
	static Logger log = Logger.getLogger(ProcessStepService.class.getName());
	
	//==============================
	//Get methods
	//==============================	
	public List<ProcessStepTo> getProcessStepByProductionProcessId(int productionProcessId) throws Exception{
		return processStepDao.getProcessStepByProductionProcessId(productionProcessId);
	}
	
	
	//==============================
	//Create, Update, Delete
	//==============================
	@Transactional
	public void saveOrUpdateProcessStepList(List<ProcessStepTo> listProcessStep)throws Exception{
		ProcessStepTo processStepTo;
		
		for(int i = 0; i < listProcessStep.size(); i++){
			processStepTo = listProcessStep.get(i);
			processStepDao.saveOrUpdateProcessStep(processStepTo);
		}
	}
	
	@Transactional
	public void deleteProcessSteps(List<ProcessStepTo> listProcessStep)throws Exception{
		ProcessStepTo processStepTo = null;

		int len = listProcessStep.size();
		for(int i = 0; i < len; i++){
			processStepTo = listProcessStep.get(i);
			if(processStepTo.getId() > 0){
				processStepDao.delete(processStepTo.getId());
			}
		}
	}

	//==============================
	//Injected Variables
	//==============================	
	private ProcessStepDao processStepDao;

	public void setProcessStepDao(ProcessStepDao processStepDao) {
		this.processStepDao = processStepDao;
	}
}
