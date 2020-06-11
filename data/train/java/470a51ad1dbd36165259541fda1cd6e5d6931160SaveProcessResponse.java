package com.duggan.workflow.shared.responses;

import com.duggan.workflow.shared.model.ProcessDef;
import com.wira.commons.shared.response.BaseResponse;

public class SaveProcessResponse extends BaseResponse {

	private ProcessDef processDef;

	public SaveProcessResponse() {
	}

	public SaveProcessResponse(ProcessDef processDef) {
		this.processDef = processDef;
	}

	public ProcessDef getProcessDef() {
		return processDef;
	}

	public void setProcessDef(ProcessDef processDef) {
		this.processDef = processDef;
	}
}
