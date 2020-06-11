package net.simpleframework.workflow.engine;

import java.util.Properties;

import net.simpleframework.ado.query.IDataQuery;
import net.simpleframework.common.coll.KVMap;
import net.simpleframework.ctx.service.ado.db.IDbBeanService;

/**
 * Licensed under the Apache License, Version 2.0
 * 
 * @author 陈侃(cknet@126.com, 13910090885)
 *         http://code.google.com/p/simpleframework/
 *         http://www.simpleframework.net
 */
public interface IProcessService extends IVariableAware<ProcessBean>, IListenerAware<ProcessBean>,
		IScriptAware<ProcessBean>, IDbBeanService<ProcessBean> {

	/**
	 * 获取流程模型
	 * 
	 * @param process
	 * @return
	 */
	ProcessModelBean getProcessModel(ProcessBean process);

	/**
	 * 创建流程实例
	 * 
	 * @param initiateItem
	 *           启动项
	 * @param topic
	 *           主题
	 * @return
	 */
	ProcessBean startProcess(InitiateItem initiateItem, String topic);

	ProcessBean startProcess(InitiateItem initiateItem);

	/**
	 * 非人工方式启动流程，一般用在子流程及接口方式
	 * 
	 * @param processModel
	 * @param variables
	 * @param properties
	 * @param topic
	 * @return
	 */
	ProcessBean startProcess(ProcessModelBean processModel, KVMap variables, Properties properties,
			String topic);

	IDataQuery<ProcessBean> getProcessList(ProcessModelBean processModel, EProcessStatus... status);

	/**
	 * 挂起及恢复流程
	 * 
	 * @param process
	 * @param resume
	 */
	void suspend(ProcessBean process, boolean resume);

	/**
	 * 放弃流程实例
	 * 
	 * @param process
	 * @param policy
	 */
	void abort(ProcessBean process, EProcessAbortPolicy policy);

	/**
	 * 子流程返回到主流程
	 * 
	 * @param process
	 */
	void backToRemote(ProcessBean process);

	/**
	 * 获取创建流程后，当前流程启动者的第一个工作项
	 * 
	 * @param process
	 * @return
	 */
	WorkitemBean getFirstWorkitem(ProcessBean process);

	/**
	 * 是否最终状态，不可状态转换
	 * 
	 * @param process
	 * @return
	 */
	boolean isFinalStatus(ProcessBean process);

	/**
	 * 设置流程标题
	 * 
	 * @param process
	 * @param title
	 */
	void setProcessTitle(ProcessBean process, String title);
}
