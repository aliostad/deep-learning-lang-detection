package com.sensus.dm.common.process.bcf;

import com.sensus.dm.common.process.model.request.ProcessRequest;
import com.sensus.dm.common.process.model.response.InquiryProcessResponse;
import com.sensus.dm.common.process.model.response.ProcessResponse;

/**
 * The Interface IProcessBCF.
 * 
 * @author QAT Global
 */
public interface IProcessSummaryBCF
{
	/**
	 * Fetch all demand response setup.
	 * 
	 * @param processRequest the process request
	 * @return the process response
	 */
	ProcessResponse fetchAllDemandResponseSetup(ProcessRequest processRequest);

	/**
	 * Fetch demand response program participation.
	 * 
	 * @param processRequest the process request
	 * @return the process response
	 */
	ProcessResponse fetchDemandResponseProgramParticipation(ProcessRequest processRequest);

	/**
	 * Fetch demand response summary.
	 * 
	 * @param processRequest the process request
	 * @return the process response
	 */
	ProcessResponse fetchDemandResponseSummary(ProcessRequest processRequest);

	/**
	 * Fetch process send han text message.
	 * 
	 * @param processRequest the process request
	 * @return the inquiry process response
	 */
	InquiryProcessResponse fetchProcessSendHanTextMessage(ProcessRequest processRequest);

}
