package com.lucazamador.drools.monitor.console.model.ksession.metric;

import java.util.Date;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import com.lucazamador.drools.monitor.model.ksession.KnowledgeProcessInstanceMetric;

@XmlRootElement(name = "processInstanceMetric")
public class KnowledgeProcessInstanceMetricData {

    private Long id;
    private Long processInstanceId;
    private Date processStarted;
    private Date processCompleted;
    private Integer processNodeTriggered;

    public KnowledgeProcessInstanceMetricData() {
    }

    public KnowledgeProcessInstanceMetricData(KnowledgeProcessInstanceMetric processInstanceMetric) {
        this.processInstanceId = processInstanceMetric.getProcessInstanceId();
        this.processStarted = processInstanceMetric.getProcessStarted();
        this.processCompleted = processInstanceMetric.getProcessCompleted();
        this.processNodeTriggered = processInstanceMetric.getProcessNodeTriggered();
    }

    @XmlElement
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @XmlElement
    public Long getProcessInstanceId() {
        return processInstanceId;
    }

    public void setProcessInstanceId(Long processInstanceId) {
        this.processInstanceId = processInstanceId;
    }

    @XmlElement
    public Date getProcessStarted() {
        return processStarted;
    }

    public void setProcessStarted(Date processStarted) {
        this.processStarted = processStarted;
    }

    @XmlElement
    public Date getProcessCompleted() {
        return processCompleted;
    }

    public void setProcessCompleted(Date processCompleted) {
        this.processCompleted = processCompleted;
    }

    @XmlElement
    public Integer getProcessNodeTriggered() {
        return processNodeTriggered;
    }

    public void setProcessNodeTriggered(Integer processNodeTriggered) {
        this.processNodeTriggered = processNodeTriggered;
    }

}
