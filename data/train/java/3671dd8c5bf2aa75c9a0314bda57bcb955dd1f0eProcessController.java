package com.ling2.uflo.console.rest.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ling2.uflo.model.ProcessInstance;
import com.ling2.uflo.service.ProcessService;
import com.ling2.uflo.service.StartProcessInfo;

/**
 * @author Jacky.gao
 * @since 2013年9月22日
 */
@Controller
public class ProcessController {
	@Autowired
	@Qualifier(ProcessService.BEAN_ID)
	private ProcessService processService;
	
	@RequestMapping(method=RequestMethod.POST,value="/uflo/process/start/id/{processId}")
	public @ResponseBody ProcessInstance startProcessById(@PathVariable long processId,@RequestBody StartProcessInfo info){
		return processService.startProcessById(processId, info);
	}
	
	@RequestMapping(method=RequestMethod.POST,value="/uflo/process/start/key/{processKey}")
	public @ResponseBody ProcessInstance startProcessByKey(@PathVariable String processKey,@RequestBody StartProcessInfo info){
		return processService.startProcessByKey(processKey, info);
	}
	
	@RequestMapping(method=RequestMethod.POST,value="/uflo/process/start/name/{processName}")
	public @ResponseBody ProcessInstance startProcessByName(@PathVariable String processName,@RequestBody StartProcessInfo info){
		return processService.startProcessByName(processName, info);
	}
	
	@RequestMapping(method=RequestMethod.POST,value="/uflo/processinstance/delete/{processInstanceId}")
	public @ResponseBody void deleteProcessInstance(@PathVariable long processInstanceId){
		processService.deleteProcessInstanceById(processInstanceId);
	}
	
	@RequestMapping(method=RequestMethod.POST,value="/uflo/process/updatememory/id/{processId}")
	public @ResponseBody void updateProcessForMemory(@PathVariable long processId){
		processService.updateProcessForMemory(processId);
	}
	@RequestMapping(method=RequestMethod.POST,value="/uflo/process/delete/id/{processId}")
	public @ResponseBody void deleteProcessById(@PathVariable long processId){
		processService.deleteProcess(processId);
	}
	@RequestMapping(method=RequestMethod.POST,value="/uflo/process/deletememory/id/{processId}")
	public @ResponseBody void deleteProcessFromMemory(@PathVariable long processId){
		processService.deleteProcessFromMemory(processId);
	}
	
	@RequestMapping(method=RequestMethod.POST,value="/uflo/process/delete/key/{processKey}")
	public @ResponseBody void deleteProcessByKey(String processKey){
		processService.deleteProcess(processKey);
	}
}
