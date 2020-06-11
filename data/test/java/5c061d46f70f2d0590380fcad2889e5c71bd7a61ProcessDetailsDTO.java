package com.scriptengine.script.workflow.dto;

import java.util.List;

/**
 * Process Details DTO class for containing process related details
 * 
 * @author Shirish Singh
 */
public class ProcessDetailsDTO {

    private String processId;

    private String processDescription;

    private List<String> processVariables;

    /**
     * @return processId
     */
    public String getProcessId() {
        return processId;
    }
    
    /**
     * @param processId
     */
    public void setProcessId(String processId) {
        this.processId = processId;
    }

    /**
     * @return processDescription
     */
    public String getProcessDescription() {
        return processDescription;
    }

    /**
     * @param processDescription
     */
    public void setProcessDescription(String processDescription) {
        this.processDescription = processDescription;
    }
    
    /**
     * @return processVariables
     */
    public List<String> getProcessVariables() {
        return processVariables;
    }
    
    /**
     * @param processVariables
     */
    public void setProcessVariables(List<String> processVariables) {
        this.processVariables = processVariables;
    }
}
