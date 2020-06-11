package ua.windriver.model.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import ua.windriver.model.automation.StartMethodNameOption;

public class AttachToProcessByProcessIdRequest extends ApplicationControlRequest{

    @JsonProperty
    private Integer processId;

    public AttachToProcessByProcessIdRequest(Integer processId){
        setMethodName(StartMethodNameOption.ATTACH_TO_PROCESS_BY_PROCESS_ID);
        this.processId = processId;
    }

    public Integer getProcessId() {
        return processId;
    }

    public void setProcessId(Integer processId) {
        this.processId = processId;
    }
}
