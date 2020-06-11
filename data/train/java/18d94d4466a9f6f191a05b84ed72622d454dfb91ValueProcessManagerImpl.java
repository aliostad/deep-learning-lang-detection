package com.loveahu.service.aop.impl;

import java.util.ArrayList;
import java.util.List;

import com.loveahu.service.aop.IValueProcess;
import com.loveahu.service.aop.IValueProcessManager;



/**
 * @author qinze
 * @since  Nov 9, 2010
 */
public class ValueProcessManagerImpl implements IValueProcessManager {

	private List<IValueProcess> processList = new ArrayList<IValueProcess>();

	public List<IValueProcess> getProcessList() {
		return processList;
	}

	public void setProcessList(List<IValueProcess> processList) {
		this.processList = processList;
	}

	@Override
	public List<Object> getValue(String key, Object[] args) {
		for(IValueProcess process : processList){
			if(process.isValid(key)){
				return process.getValue(key, args);
			}
		}
		return null;
	}

}
