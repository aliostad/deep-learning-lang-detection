package com.agileEAP.workflow.engine;

import java.util.Map;

import com.agileEAP.workflow.entity.ProcessInst;
import com.agileEAP.workflow.definition.*;

/** 
 流程上下文
 
*/
public class ProcessContext
{
	private ProcessDefine processDefine;
	public final ProcessDefine getProcessDefine()
	{
		return processDefine;
	}
	public final void setProcessDefine(ProcessDefine value)
	{
		processDefine = value;
	}


	private ProcessInst processInst;
	public final ProcessInst getProcessInst()
	{
		return processInst;
	}
	public final void setProcessInst(ProcessInst value)
	{
		processInst = value;
	}

	private Map<String, Object> parameters;
	public final java.util.Map<String, Object> getParameters()
	{
		return parameters;
	}
	public final void setParameters(Map<String, Object> value)
	{
		parameters = value;
	}

	public ProcessContext(ProcessDefine processDefine,ProcessInst processInst,Map<String, Object> parameters)
	{
		this.processDefine=processDefine;
		this.processInst=processInst;
		this.parameters=parameters;
	}
}