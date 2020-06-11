package uk.co.markberridge.struts;

import java.util.HashMap;
import java.util.Map;

import uk.co.markberridge.service.ProcessService;

import com.opensymphony.xwork2.ActionSupport;

public abstract class BaseProcessAction extends ActionSupport {

    private ProcessService processService;

    private Map<String, String> processVariables = new HashMap<String, String>();;

    public ProcessService getProcessService() {
        return processService;
    }

    public void setProcessService(ProcessService processService) {
        this.processService = processService;
    }

    public Map<String, String> getProcessVariables() {
        return processVariables;
    }

    public void setProcessVariables(Map<String, String> processVariables) {
        this.processVariables = processVariables;
    }
}
