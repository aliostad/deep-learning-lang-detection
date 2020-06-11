package us.wthr.jdem846ui.views.modelconfig;

import java.util.LinkedList;
import java.util.List;

import us.wthr.jdem846.model.processing.GridProcessingTypesEnum;
import us.wthr.jdem846.model.processing.ModelProcessRegistry;
import us.wthr.jdem846.model.processing.ProcessInstance;

public class ProcessTypeListModel {
	
	private GridProcessingTypesEnum processType;
	
	private List<ProcessInstance> processList = new LinkedList<ProcessInstance>();
	
	public ProcessTypeListModel(GridProcessingTypesEnum processType)
	{
		this.processType = processType;
		
		
		List<ProcessInstance> processInstanceList = ModelProcessRegistry.getInstances();
		
		for (ProcessInstance processInstance : processInstanceList) {
			
			if (processInstance.getType() == processType) {
				processList.add(processInstance);
			}
			
		}
	}

	public GridProcessingTypesEnum getProcessType() {
		return processType;
	}
	
	
	public int getProcessListSize()
	{
		return processList.size();
	}
	
	public String getProcessNameAtIndex(int index)
	{
		return processList.get(index).getName();
	}
	
	public String getProcessIdAtIndex(int index)
	{
		return processList.get(index).getId();
	}
	
	
	public String getIdByProcessName(String name)
	{
		for (ProcessInstance processInstance : processList) {
			if (processInstance.getName().equals(name)) {
				return processInstance.getId();
			}
		}
		
		return null;
	}
	
	public String getNameByProcessId(String id)
	{
		for (ProcessInstance processInstance : processList) {
			if (processInstance.getId().equals(id)) {
				return processInstance.getName();
			}
		}
		
		return null;
	}
}
