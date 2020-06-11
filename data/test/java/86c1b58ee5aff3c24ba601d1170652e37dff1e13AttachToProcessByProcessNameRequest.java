package ua.windriver.model.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import ua.windriver.model.automation.StartMethodNameOption;

public class AttachToProcessByProcessNameRequest extends ApplicationControlRequest {

    @JsonProperty
    private String processName;

    public AttachToProcessByProcessNameRequest(String processName) {
        setMethodName(StartMethodNameOption.ATTACH_TO_PROCESS_BY_PROCESS_NAME);
        this.processName = processName;
    }

    public String getProcessName() {
        return processName;
    }

    public void setProcessName(String processName) {
        this.processName = processName;
    }
}
