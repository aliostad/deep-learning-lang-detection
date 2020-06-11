package com.pearl.normandy.productionprocess;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.transaction.annotation.Transactional;

import com.pearl.normandy.processstep.ProcessStepDao;
import com.pearl.normandy.processstep.ProcessStepService;
import com.pearl.normandy.processstep.ProcessStepTo;
import com.pearl.normandy.utils.Constants;

public class ProductionProcessService {
	static Logger log = Logger.getLogger(ProductionProcessService.class.getName());
	
	//==============================
	//Get methods
	//==============================	
	public List<ProductionProcessTo> getProcessByProjectId(Integer projectId, boolean getDefault)throws Exception{
		List<ProductionProcessTo> listProcess = productionProcessDao.getProcessByProjectId(projectId);
		List<ProcessStepTo> listProcessStep = processStepDao.getProcessStepByProjectId(projectId);

		listProcess = assembleProcessHierarchical(listProcess, listProcessStep);
		if (getDefault){
			listProcess.add(0, ProductionProcessTo.getDefault());
		}		

		return listProcess;
	}				
	
	
	public List<ProductionProcessTo> assembleProcessHierarchical(List<ProductionProcessTo> listProcess, List<ProcessStepTo> listProcessStep)throws Exception{
		ProductionProcessTo processTo = null;
		ProcessStepTo processStepTo = null;
		int j = 0;

		int processLen = listProcess.size();
		for(int i = 0; i < processLen; i++){
			processTo = (ProductionProcessTo)listProcess.get(i);
			ArrayList<ProcessStepTo> children = new ArrayList<ProcessStepTo>();
			while(j < listProcessStep.size()){		
				processStepTo = (ProcessStepTo)listProcessStep.get(j);
				j++;
				if (processStepTo.getProductionProcessId()!= null && processStepTo.getProductionProcessId().equals(processTo.getId())) {
					children.add(processStepTo);
				}
			}
			if(children.size() > 0){
				processTo.setProcessSteps(children);
			}
			j = 0;
		}

		return listProcess;
	}
	
	//==============================
	//Create, Update, Delete
	//==============================	
	public void saveProcess(List<ProductionProcessTo> processes) throws Exception {
		for (int i = 0; i < processes.size(); i++) {
			ProductionProcessTo process = processes.get(i);
			saveProcess(process);
		}		
	}
	
	
	@Transactional
	protected void saveProcess(ProductionProcessTo processTo) throws Exception{		
		ProductionProcess process = productionProcessDao.save(processTo);
		if(processTo.getId() < 1){
			processTo.setId(process.getId());
		}

		List<ProcessStepTo> listProcessStep = processTo.getProcessSteps();
		if(listProcessStep == null){			
			return;
		}
		
		//Set productionProcessId in steps
		ProcessStepTo processStepTo;
		for(int i = 0; i < listProcessStep.size(); i++){
			processStepTo = listProcessStep.get(i);
			if(processStepTo.getProductionProcessId() < 1){				
				processStepTo.setProductionProcessId(processTo.getId());
			}
		}
		processStepService.saveOrUpdateProcessStepList(listProcessStep);
	}

	
	@Transactional	
	public void deleteProcess(ProductionProcessTo productionProcessTo) throws Exception{
		processStepDao.deleteByProcessId(productionProcessTo.getId());
		productionProcessDao.delete(productionProcessTo.getId());
	}
	
	//==============================
	//Injected Variables
	//==============================	
	private ProductionProcessDao productionProcessDao;
	private ProcessStepDao processStepDao;
	private ProcessStepService processStepService;
	
	public void setProductionProcessDao(ProductionProcessDao productionProcessDao) {
		this.productionProcessDao = productionProcessDao;
	}
	public void setProcessStepDao(ProcessStepDao processStepDao) {
		this.processStepDao = processStepDao;
	}
	public void setProcessStepService(ProcessStepService processStepService) {
		this.processStepService = processStepService;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//==========================Ready to delete ======================	
	public List<ProductionProcessTo> getProcessForQAUser(Integer projectId, Integer userId)throws Exception{
		List<ProductionProcessTo> listProcess = null;
		List<ProcessStepTo> listProcessStep = null;

		listProcess = productionProcessDao.getProcessByProjectAndUserId(projectId, userId, Constants.PROJECT_ROLE_QA_NUM);
		listProcessStep = processStepDao.getProcessStepByProjectId(projectId);
		listProcess = assembleProcessHierarchical(listProcess, listProcessStep);

		return listProcess;
	}		
	
	
	public List<ProductionProcessTo> getProductionProcessByProjectIdAndTaskCategoryId(
			Integer projectId, Integer taskCategoryId)throws Exception{
		List<ProductionProcessTo> result = null;

		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("projectId", projectId);
		map.put("taskCategoryId", taskCategoryId);
		result = productionProcessDao.getProductionProcessByProjectIdAndTaskCategoryId(map);

		return result;
	}	
}
