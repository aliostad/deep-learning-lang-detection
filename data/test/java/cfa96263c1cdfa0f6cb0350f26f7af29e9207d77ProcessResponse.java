package com.sensus.dm.common.process.model.response;

import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.xml.bind.annotation.XmlElement;

import com.sensus.common.model.response.Response;
import com.sensus.dm.common.process.model.DMProcess;
import com.sensus.dm.common.process.model.ProcessCategory;
import com.sensus.dm.common.process.model.ProcessItem;
import com.sensus.dm.common.process.model.ProcessType;

/**
 * The Class ProcessResponse.
 * 
 * @author QAT Brazil.
 */
public class ProcessResponse extends Response
{

	/** The processes. */
	@XmlElement(nillable = true)
	private List<DMProcess> processes;

	/** The fileName. */
	private String fileName;

	/** The link status. */
	private Boolean linkStatus;

	/** The count monitored process. */
	private HashMap<String, Integer> countMonitoredProcess;

	/** The action type enum. */
	private List<ProcessType> processTypes;

	/** The process categories. */
	private List<ProcessCategory> processCategories;

	/** The process response time. */
	private Date processResponseTime;

	/** The process items. */
	private List<ProcessItem> processItems;

	/**
	 * Sets the processes.
	 * 
	 * @param processesParam the new processes
	 */
	public void setProcesses(List<DMProcess> processesParam)
	{
		processes = processesParam;
	}

	/**
	 * Gets the file name.
	 * 
	 * @return the file name
	 */
	public String getFileName()
	{
		return fileName;
	}

	/**
	 * Sets the file name.
	 * 
	 * @param fileName the new file name
	 */
	public void setFileName(String fileName)
	{
		this.fileName = fileName;
	}

	/**
	 * Gets the processes.
	 * 
	 * @return the processes
	 */
	public List<DMProcess> getProcesses()
	{
		return processes;
	}

	/**
	 * Gets the link status.
	 * 
	 * @return the linkStatus
	 */
	public Boolean getLinkStatus()
	{
		return linkStatus;
	}

	/**
	 * Sets the link status.
	 * 
	 * @param linkStatus the linkStatus to set
	 */
	public void setLinkStatus(Boolean linkStatus)
	{
		this.linkStatus = linkStatus;
	}

	/**
	 * Gets the count monitored process.
	 * 
	 * @return the count monitored process
	 */
	public HashMap<String, Integer> getCountMonitoredProcess()
	{
		return countMonitoredProcess;
	}

	/**
	 * Sets the count monitored process.
	 * 
	 * @param countMonitoredProcess the count monitored process
	 */
	public void setCountMonitoredProcess(HashMap<String, Integer> countMonitoredProcess)
	{
		this.countMonitoredProcess = countMonitoredProcess;
	}

	/**
	 * Gets the action types.
	 * 
	 * @return the actionTypes
	 */
	public List<ProcessType> getProcessTypes()
	{
		return processTypes;
	}

	/**
	 * Sets the action types.
	 * 
	 * @param processTypes the new process types
	 */
	public void setProcessTypes(List<ProcessType> processTypes)
	{
		this.processTypes = processTypes;
	}

	/**
	 * Gets the process categories.
	 * 
	 * @return the process categories
	 */
	public List<ProcessCategory> getProcessCategories()
	{
		return processCategories;
	}

	/**
	 * Sets the process categories.
	 * 
	 * @param processCategoriesParam the new process categories
	 */
	public void setProcessCategories(List<ProcessCategory> processCategoriesParam)
	{
		processCategories = processCategoriesParam;
	}

	/**
	 * Gets the process response time.
	 * 
	 * @return the processResponseTime
	 */
	public Date getProcessResponseTime()
	{
		return processResponseTime;
	}

	/**
	 * Sets the process response time.
	 * 
	 * @param processResponseTime the processResponseTime to set
	 */
	public void setProcessResponseTime(Date processResponseTime)
	{
		this.processResponseTime = processResponseTime;
	}

	/**
	 * Gets the process items.
	 * 
	 * @return the process items
	 */
	public List<ProcessItem> getProcessItems()
	{
		return processItems;
	}

	/**
	 * Sets the process items.
	 * 
	 * @param processItemsParam the new process items
	 */
	public void setProcessItems(List<ProcessItem> processItemsParam)
	{
		processItems = processItemsParam;
	}

	/*
	 * (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString()
	{
		return "ProcessResponse [getFileName()=" + getFileName() + ", getProcesses()=" + getProcesses()
				+ ", getLinkStatus()=" + getLinkStatus() + ", getCountMonitoredProcess()=" + getCountMonitoredProcess()
				+ ", getProcessTypes()=" + getProcessTypes() + ", getProcessCategories()=" + getProcessCategories()
				+ ", getProcessResponseTime()=" + getProcessResponseTime() + ", getProcessItems()=" + getProcessItems()
				+ ", getMessageIterator()=" + getMessageIterator() + ", getMessageList()=" + getMessageList()
				+ ", getMessageInfoList()=" + getMessageInfoList() + ", isOperationSuccess()=" + isOperationSuccess()
				+ "]";
	}
}
