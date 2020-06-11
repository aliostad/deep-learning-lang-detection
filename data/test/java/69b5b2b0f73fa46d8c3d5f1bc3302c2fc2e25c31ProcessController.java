package org.bench4q.monitor.api;

import java.util.ArrayList;
import java.util.concurrent.ExecutionException;

import org.bench4q.monitor.model.ProcessModel;
import org.bench4q.monitor.model.ProcessModelChild;
import org.bench4q.monitor.model.ProcessSigarReleatedModel;
import org.hyperic.sigar.SigarException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/monitor")
class ProcessController {
	@RequestMapping("/process")
	@ResponseBody
	public ProcessModel getProcessModel() throws SigarException, InterruptedException, ExecutionException {
		ProcessModel processModel = new ProcessModel();
		return processModel;
	}
	@RequestMapping("/process/pid/{pid}")
	@ResponseBody
	public ProcessModelChild getProcessModelChild(@PathVariable("pid") long pid)
			throws SigarException {
		ProcessSigarReleatedModel processSigarReleatedModel=new ProcessSigarReleatedModel(pid);
	 ProcessModelChild processModelChild=new ProcessModelChild(pid, processSigarReleatedModel);
	 return processModelChild;
	
	}
	@RequestMapping("/process/name/{processName}")
	@ResponseBody
	public ProcessModelChild getProcessModelChild(@PathVariable("processName") String  name)
			throws SigarException, InterruptedException, ExecutionException {
		ProcessModel processModel=new ProcessModel();
		ArrayList<ProcessModelChild> proList=(ArrayList<ProcessModelChild>) processModel.getProcesModelList();
		if(proList!=null){
			for(ProcessModelChild processModelChild:proList){
				if(processModelChild.getInstanceString().equals(name))
					return processModelChild;
			}
		}
	throw new IllegalArgumentException("process:"+name+" not exit");
	}
}
