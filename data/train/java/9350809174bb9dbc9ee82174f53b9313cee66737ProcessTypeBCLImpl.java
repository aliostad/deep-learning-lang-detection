package com.sensus.dm.common.process.bcl.impl;

import com.sensus.common.model.response.InternalResultsResponse;
import com.sensus.dm.common.process.bcl.IProcessTypeBCL;
import com.sensus.dm.common.process.dac.IProcessTypeDAC;
import com.sensus.dm.common.process.model.ProcessCategory;
import com.sensus.dm.common.process.model.ProcessType;
import com.sensus.dm.common.process.model.request.ProcessRequest;

/**
 * The Class ProcessTypeBCLImpl.
 * 
 * @author QAT Global
 */
public class ProcessTypeBCLImpl implements IProcessTypeBCL
{

	// -------------------------------------------------------------------------
	// -------------------------------------------------------------------------
	// -------------------------------------------------------------------------
	// -------------------------------------------------------------------------
	// -------------------------------------------------------------------------
	// Spring injection points:

	/** The process dac. */
	private IProcessTypeDAC processTypeDAC;

	// -------------------------------------------------------------------------
	// -------------------------------------------------------------------------
	// -------------------------------------------------------------------------
	// -------------------------------------------------------------------------
	// -------------------------------------------------------------------------
	// Public interface:

	/**
	 * Gets the process type dac.
	 * 
	 * @return the process type dac
	 */
	public IProcessTypeDAC getProcessTypeDAC()
	{
		return processTypeDAC;
	}

	/**
	 * Sets the process type dac.
	 * 
	 * @param processTypeDAC the new process type dac
	 */
	public void setProcessTypeDAC(IProcessTypeDAC processTypeDAC)
	{
		this.processTypeDAC = processTypeDAC;
	}

	/**
	 * Fetch process type by description.
	 * 
	 * @param processRequest the process request
	 * @return the internal results response
	 */
	@Override
	public InternalResultsResponse<ProcessType> fetchProcessTypeByDescription(ProcessRequest processRequest)
	{
		return getProcessTypeDAC().fetchProcessTypeByDescription(processRequest);
	}

	/*
	 * (non-Javadoc)
	 * @see
	 * com.sensus.dm.common.process.bcl.IProcessTypeBCL#fetchAllProcessCategory(com.sensus.dm.common.process.model.request
	 * .ProcessRequest)
	 */
	@Override
	public InternalResultsResponse<ProcessCategory> fetchAllProcessCategory(ProcessRequest processRequest)
	{
		return getProcessTypeDAC().fetchAllProcessCategory(processRequest);
	}

}
