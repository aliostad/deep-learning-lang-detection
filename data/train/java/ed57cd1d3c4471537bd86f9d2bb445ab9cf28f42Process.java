package org.freaknowledge;

import java.util.Map;

public abstract class Process extends Fact {

    private static final long serialVersionUID = -6212132833116045895L;

    private Map<String, Object> parameters;

    private Long processInstanceId;

    private String processId;

    public Long getProcessInstanceId() {

        return processInstanceId;
    }

    public void setProcessInstanceId(Long processInstanceId) {

        this.processInstanceId = processInstanceId;
    }

    public Map<String, Object> getParameters() {

        return parameters;
    }

    public void setParameters(Map<String, Object> parameters) {

        this.parameters = parameters;
    }

    public String getProcessId() {

        return processId;
    }

    public void setProcessId(String processId) {

        this.processId = processId;
    }
}
