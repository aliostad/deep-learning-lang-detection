package com.ling2.uflo.command.impl;

import com.ling2.uflo.command.Command;
import com.ling2.uflo.env.Context;
import com.ling2.uflo.model.ProcessInstance;

/**
 * @author Jacky.gao
 * @since 2013年7月31日
 */
public class GetProcessInstanceCommand implements Command<ProcessInstance> {
	private long processInstanceId;
	public GetProcessInstanceCommand(long processInstanceId){
		this.processInstanceId=processInstanceId;
	}
	public ProcessInstance execute(Context context) {
		return (ProcessInstance)context.getSession().get(ProcessInstance.class, processInstanceId);
	}
}
