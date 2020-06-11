package com.sensus.dm.common.process.bcf;

import com.sensus.dm.common.process.model.request.InquiryProcessRequest;
import com.sensus.dm.common.process.model.request.ProcessRequest;
import com.sensus.dm.common.process.model.response.InquiryProcessResponse;
import com.sensus.dm.common.process.model.response.ProcessResponse;

/**
 * The Interface IProcessBCF.
 * 
 * @author QAT Global
 */
public interface IProcessBCF
{
	/**
	 * Update process.
	 * 
	 * @param processRequest the process request
	 * @return the process response
	 */
	ProcessResponse updateProcess(ProcessRequest processRequest);

	/**
	 * Fetch processes.
	 * 
	 * @param inquiryProcessRequest the inquiry process request
	 * @return the inquiry process response
	 */
	InquiryProcessResponse fetchProcesses(InquiryProcessRequest inquiryProcessRequest);

	/**
	 * Fetch process by id.
	 * 
	 * @param processRequest the process request
	 * @return the inquiry process response
	 */
	InquiryProcessResponse fetchProcessById(ProcessRequest processRequest);

	/**
	 * Fetch monitored process.
	 * 
	 * @param inquiryProcessRequest the inquiry process request
	 * @return the inquiry process response
	 */
	InquiryProcessResponse fetchMonitoredProcess(InquiryProcessRequest inquiryProcessRequest);

	/**
	 * Fetch count monitored processes.
	 * 
	 * @param processRequest the process request
	 * @return the process response
	 */
	ProcessResponse fetchCountMonitoredProcesses(ProcessRequest processRequest);

	/**
	 * Fetch today processes.
	 * 
	 * @param inquiryProcessRequest the inquiry process request
	 * @return the inquiry process response
	 */
	InquiryProcessResponse fetchTodayProcesses(InquiryProcessRequest inquiryProcessRequest);

	/**
	 * Check link status.
	 * 
	 * @param processRequest the process request
	 * @return the process response
	 */
	ProcessResponse checkLinkStatus(ProcessRequest processRequest);

	/**
	 * Fetch communication summary.
	 * 
	 * @param processRequest the process request
	 * @return the process response
	 */
	ProcessResponse fetchCommunicationSummary(ProcessRequest processRequest);

	/**
	 * Fetch import han device summary.
	 * 
	 * @param processRequest the process request
	 * @return the process response
	 */
	ProcessResponse fetchImportHanDeviceSummary(ProcessRequest processRequest);

	/**
	 * Fetch demand read ping summary.
	 * 
	 * @param processRequest the process request
	 * @return the process response
	 */
	ProcessResponse fetchDemandReadPingSummary(ProcessRequest processRequest);

	/**
	 * Fetch process items by schedule.
	 * 
	 * @param processRequest the process request
	 * @return the process response
	 */
	ProcessResponse fetchProcessItemsBySchedule(ProcessRequest processRequest);

	/**
	 * Fetch process items by process id.
	 * 
	 * @param processRequest the process request
	 * @return the process response
	 */
	ProcessResponse fetchProcessItemsByProcessId(ProcessRequest processRequest);

	/**
	 * Fetch all process items.
	 * 
	 * @param processRequest the process request
	 * @return the process response
	 */
	ProcessResponse fetchAllProcessItems(ProcessRequest processRequest);

	/**
	 * Update process items to expire.
	 * 
	 * @param processRequest the process request
	 * @return the process response
	 */
	ProcessResponse updateProcessItemsToExpire(ProcessRequest processRequest);

	/**
	 * Fetch relays.
	 * 
	 * @param processRequest the process request
	 * @return the process response
	 */
	ProcessResponse fetchRelays(ProcessRequest processRequest);

	/**
	 * Fetch relays by process id.
	 * 
	 * @param processRequest the process request
	 * @return the process response
	 */
	ProcessResponse fetchRelaysByProcessId(ProcessRequest processRequest);

}
