package com.sensus.lc.process.bcf;

import com.sensus.lc.base.model.request.InquiryPaginationRequest;
import com.sensus.lc.light.model.request.LightRequest;
import com.sensus.lc.light.model.response.CSVResponse;
import com.sensus.lc.process.model.request.InquiryProcessRequest;
import com.sensus.lc.process.model.request.ProcessCSVRequest;
import com.sensus.lc.process.model.request.ProcessRequest;
import com.sensus.lc.process.model.response.InquiryProcessResponse;
import com.sensus.lc.process.model.response.ProcessResponse;

/**
 * The Interface IProcessBCF.
 */
public interface IProcessBCF
{
	/**
	 * Insert process.
	 * 
	 * @param processRequest the process request
	 * @return the process response
	 */
	ProcessResponse insertProcess(ProcessRequest processRequest);

	/**
	 * Update process.
	 * 
	 * @param processRequest the process request
	 * @return the process response
	 */
	ProcessResponse updateProcess(ProcessRequest processRequest);

	/**
	 * Unmonitor process.
	 * 
	 * @param processRequest the process request
	 * @return the process response
	 */
	ProcessResponse unmonitorProcess(ProcessRequest processRequest);

	/**
	 * Fetch monitored processes.
	 * 
	 * @param processRequest the process request
	 * @return the process response
	 */
	ProcessResponse fetchMonitoredProcesses(ProcessRequest processRequest);

	/**
	 * Fetch all process.
	 * 
	 * @param processRequest the process request
	 * @return the inquiry process response
	 */
	InquiryProcessResponse fetchAllProcess(InquiryProcessRequest processRequest);

	/**
	 * Fetch process by id.
	 * 
	 * @param processRequest the process request
	 * @return the process response
	 */
	ProcessResponse fetchProcessById(ProcessRequest processRequest);

	/**
	 * Fetch process by transaction id.
	 * 
	 * @param processRequest the process request
	 * @return the process response
	 */
	ProcessResponse fetchProcessByTransactionId(ProcessRequest processRequest);

	/**
	 * Retry process.
	 * 
	 * @param processRequest the process request
	 * @return the process response
	 */
	ProcessResponse retryProcess(ProcessRequest processRequest);

	/**
	 * Abort process.
	 * 
	 * @param processRequest the process request
	 * @return the process response
	 */
	ProcessResponse abortProcess(ProcessRequest processRequest);

	/**
	 * Fetch process by light.
	 * 
	 * @param lightRequest the light request
	 * @return the process response
	 */
	ProcessResponse fetchProcessByLight(LightRequest lightRequest);

	/**
	 * Fetch rni link status.
	 * 
	 * @param processRequest the process request
	 * 
	 * @return the process response
	 */
	ProcessResponse fetchRniLinkStatus(ProcessRequest processRequest);

	/**
	 * Update csv downloaded.
	 * 
	 * @param processRequest the process request
	 * @return the process response
	 */
	ProcessResponse updateCSVDownloaded(ProcessRequest processRequest);

	/**
	 * Generate sumary file csv.
	 * 
	 * @param processRequest the process request
	 * @return the process response
	 */
	ProcessResponse generateSummaryFileCSV(ProcessRequest processRequest);

	/**
	 * Fetch count monitored processes.
	 * 
	 * @param processRequest the process request
	 * @return the process response
	 */
	ProcessResponse fetchCountMonitoredProcesses(ProcessRequest processRequest);

	/**
	 * Insert csv process.
	 * 
	 * @param request the request
	 * @return the process response
	 */
	ProcessResponse insertCSVProcess(InquiryPaginationRequest request);

	/**
	 * Generate file csv.
	 * 
	 * @param request the request
	 * @return the cSV response
	 */
	CSVResponse generateFileCSV(ProcessCSVRequest request);

	/**
	 * Fetch summary by process id.
	 * 
	 * @param processRequest the process request
	 * @return the process response
	 */
	ProcessResponse fetchSummaryByProcessId(ProcessRequest processRequest);

}
