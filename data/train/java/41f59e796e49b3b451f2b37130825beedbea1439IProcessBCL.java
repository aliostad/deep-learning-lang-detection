/*
 *
 */
package com.sensus.mlc.process.bcl;

import java.util.HashMap;

import com.sensus.common.model.response.InternalResponse;
import com.sensus.common.model.response.InternalResultsResponse;
import com.sensus.mlc.base.model.request.LightSelectionRequest;
import com.sensus.mlc.process.model.LCAction;
import com.sensus.mlc.process.model.Process;
import com.sensus.mlc.process.model.request.InquiryProcessRequest;
import com.sensus.mlc.process.model.request.ProcessRequest;
import com.sensus.mlc.process.model.response.InquiryProcessResponse;
import com.sensus.mlc.process.model.response.ProcessResponse;
import com.sensus.mlc.smartpoint.model.request.LightRequest;
import com.sensus.mlc.tenant.model.Tenant;

/**
 * The Interface IProcessBCL.
 */
public interface IProcessBCL
{
	/**
	 * Insert process.
	 * 
	 * @param processRequest the process request
	 * @return the internal results response
	 */
	InternalResultsResponse<Process> insertProcess(ProcessRequest processRequest);

	/**
	 * Update process.
	 * 
	 * @param processRequest the process request
	 * @return the internal response
	 */
	InternalResponse updateProcess(ProcessRequest processRequest);

	/**
	 * Unmonitor process.
	 * 
	 * @param processRequest the process request
	 * @return the internal response
	 */
	InternalResponse unmonitorProcess(ProcessRequest processRequest);

	/**
	 * Fetch processes.
	 * 
	 * @param processRequest the process request
	 * @return the internal results response
	 */
	InternalResultsResponse<Process> fetchProcesses(InquiryProcessRequest processRequest);

	/**
	 * Fetch process by id.
	 * 
	 * @param processRequest the process request
	 * @return the internal results response
	 */
	InternalResultsResponse<Process> fetchProcessById(ProcessRequest processRequest);

	/**
	 * Fetch process by rni id.
	 * 
	 * @param processRequest the process request
	 * @return the internal results response
	 */
	InternalResultsResponse<Process> fetchProcessByRniId(ProcessRequest processRequest);

	/**
	 * Fetch process by file name.
	 * 
	 * @param processRequest the process request
	 * @return the internal results response
	 */
	InternalResultsResponse<Process> fetchProcessByFileName(ProcessRequest processRequest);

	/**
	 * Fetch monitored processes.
	 * 
	 * @param processRequest the process request
	 * @return the internal results response
	 */
	InternalResultsResponse<Process> fetchMonitoredProcesses(ProcessRequest processRequest);

	/**
	 * Retry process.
	 * 
	 * @param processRequest the process request
	 * @return the internal response
	 */
	InternalResponse retryProcess(ProcessRequest processRequest);

	/**
	 * Abort process.
	 * 
	 * @param processRequest the process request
	 * @return the internal response
	 */
	InternalResponse abortProcess(ProcessRequest processRequest);

	/**
	 * Fetch process by light.
	 * 
	 * @param lightRequest the light request
	 * @return the internal results response
	 */
	InternalResultsResponse<Process> fetchProcessByLight(LightRequest lightRequest);

	/**
	 * Submit process.
	 * 
	 * @param processRequest the process request
	 * @param action the action
	 * @return the internal results response
	 */
	InternalResultsResponse<Process> submitProcess(ProcessRequest processRequest, LCAction action);

	/**
	 * Fetch rni link status.
	 * 
	 * @param tenant the tenant
	 * @return the boolean
	 */
	InternalResultsResponse<Boolean> fetchRniLinkStatus(Tenant tenant);

	/**
	 * Check rni status.
	 */
	void checkRniStatus();

	/**
	 * Sets the gateway active.
	 * 
	 * @param tenant the tenant
	 * @param value the new gateway active
	 */
	void setGatewayActive(Tenant tenant, Boolean value);

	/**
	 * Fetch tenant by rni code.
	 * 
	 * @param rniCode the rni code
	 * @return the internal results response
	 */
	InternalResultsResponse<Tenant> fetchTenantByRniCode(String rniCode);

	/**
	 * Fetch all tenant.
	 * 
	 * @return the internal results response
	 */
	InternalResultsResponse<Tenant> fetchAllTenant();

	/**
	 * Update csv downloaded.
	 * 
	 * @param processRequest the process request
	 * @return the internal response
	 */
	InternalResponse updateCSVDownloaded(ProcessRequest processRequest);

	/**
	 * Generate sumary file csv.
	 * 
	 * @param processRequest the process request
	 * @return the process response
	 */
	ProcessResponse generateSumaryFileCSV(ProcessRequest processRequest);

	/**
	 * Fetch count monitored processes.
	 * 
	 * @param processRequest the process request
	 * @return the internal results response
	 */
	InternalResultsResponse<HashMap<String, Integer>> fetchCountMonitoredProcesses(ProcessRequest processRequest);

	/**
	 * Generate process file csvu.
	 * 
	 * @param inquiryProcessRequest the inquiry process request
	 * @return the process response
	 */
	ProcessResponse insertCSVProcess(LightSelectionRequest lightSelectionRequest);

	/**
	 * Generate file csv.
	 * 
	 * @param inquiryProcessRequest the inquiry process request
	 * @return the InquiryProcessResponse
	 */
	InquiryProcessResponse generateFileCSV(InquiryProcessRequest inquiryProcessRequest);
}
