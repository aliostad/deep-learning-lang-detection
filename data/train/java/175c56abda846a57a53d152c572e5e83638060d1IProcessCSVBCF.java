package com.sensus.dm.common.process.bcf;

import com.sensus.dm.common.process.model.request.InquiryProcessRequest;
import com.sensus.dm.common.process.model.request.ProcessRequest;
import com.sensus.dm.common.process.model.response.ProcessResponse;

/**
 * The Interface IProcessBCF.
 * 
 * @author QAT Global
 */
public interface IProcessCSVBCF
{

	/**
	 * Update csv downloaded.
	 * 
	 * @param processRequest the process request
	 * @return the process response
	 */
	ProcessResponse updateCSVDownloaded(ProcessRequest processRequest);

	/**
	 * Generate file csv summary.
	 * 
	 * @param inquiryProcessRequest the inquiry process request
	 * @return the process response
	 */
	ProcessResponse generateFileCSVSummary(InquiryProcessRequest inquiryProcessRequest);

	/**
	 * Insert csv process.
	 * 
	 * @param processRequest the process request
	 * @return the process response
	 */
	ProcessResponse insertCSVProcess(InquiryProcessRequest processRequest);

	/**
	 * Generate file csv communication summary.
	 * 
	 * @param inquiryProcessRequest the inquiry process request
	 * @return the process response
	 */
	ProcessResponse generateFileCSVCommunicationSummary(InquiryProcessRequest inquiryProcessRequest);

	/**
	 * Generate file csv demand response summary.
	 * 
	 * @param inquiryProcessRequest the inquiry process request
	 * @return the process response
	 */
	ProcessResponse generateFileCSVDemandResponseSummary(InquiryProcessRequest inquiryProcessRequest);

	/**
	 * Generate file csv demand read summary.
	 * 
	 * @param inquiryProcessRequest the inquiry process request
	 * @return the process response
	 */
	ProcessResponse generateFileCSVDemandReadSummary(InquiryProcessRequest inquiryProcessRequest);

	/**
	 * Generate file csv import han summary.
	 * 
	 * @param inquiryProcessRequest the inquiry process request
	 * @return the process response
	 */
	ProcessResponse generateFileCSVImportHanSummary(InquiryProcessRequest inquiryProcessRequest);

	/**
	 * Generate file csv today.
	 * 
	 * @param inquiryProcessRequest the inquiry process request
	 * @return the process response
	 */
	ProcessResponse generateFileCSVToday(InquiryProcessRequest inquiryProcessRequest);

	/**
	 * Generate file csv event history.
	 * 
	 * @param inquiryProcessRequest the inquiry process request
	 * @return the process response
	 */
	ProcessResponse generateFileCSVEventHistory(InquiryProcessRequest inquiryProcessRequest);

	/**
	 * Generate file csv device history.
	 * 
	 * @param inquiryProcessRequest the inquiry process request
	 * @return the process response
	 */
	ProcessResponse generateFileCSVDeviceHistory(InquiryProcessRequest inquiryProcessRequest);

	/**
	 * Generate file csv tamper detect summary.
	 * 
	 * @param inquiryProcessRequest the inquiry process request
	 * @return the process response
	 */
	ProcessResponse generateFileCSVTamperDetectSummary(InquiryProcessRequest inquiryProcessRequest);

	/**
	 * Generate file csv demand response setup summary.
	 * 
	 * @param inquiryProcessRequest the inquiry process request
	 * @return the process response
	 */
	ProcessResponse generateFileCSVDemandResponseSetupSummary(InquiryProcessRequest inquiryProcessRequest);

}
