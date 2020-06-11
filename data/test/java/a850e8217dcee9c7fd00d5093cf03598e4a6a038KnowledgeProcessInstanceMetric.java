package com.lucazamador.drools.monitor.model.ksession;

import java.io.Serializable;
import java.util.Date;

/**
 * 
 * @author Lucas Amador
 * 
 */
public class KnowledgeProcessInstanceMetric implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private Long processInstanceId;
    private Date processStarted;
    private Date processCompleted;
    private Integer processNodeTriggered;

    public KnowledgeProcessInstanceMetric() {
    }

    public KnowledgeProcessInstanceMetric(Long processInstanceId, Date processStarted, Date processCompleted,
            int processNodeTriggered) {
        this.processInstanceId = processInstanceId;
        this.processStarted = processStarted;
        this.processCompleted = processCompleted;
        this.processNodeTriggered = processNodeTriggered;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getProcessInstanceId() {
        return processInstanceId;
    }

    public void setProcessInstanceId(Long processInstanceId) {
        this.processInstanceId = processInstanceId;
    }

    public Date getProcessStarted() {
        return processStarted;
    }

    public void setProcessStarted(Date processStarted) {
        this.processStarted = processStarted;
    }

    public Date getProcessCompleted() {
        return processCompleted;
    }

    public void setProcessCompleted(Date processCompleted) {
        this.processCompleted = processCompleted;
    }

    public Integer getProcessNodeTriggered() {
        return processNodeTriggered;
    }

    public void setProcessNodeTriggered(Integer processNodeTriggered) {
        this.processNodeTriggered = processNodeTriggered;
    }

}
