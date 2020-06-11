package com.lucazamador.drools.monitor.console.model.ksession.metric;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import com.lucazamador.drools.monitor.model.ksession.KnowledgeProcessMetric;

@XmlRootElement(name = "processMetric")
public class KnowledgeProcessMetricData {

    private Long id;
    private String name;
    private Long processStarted;
    private Long processCompleted;
    private Long processNodeTriggered;

    public KnowledgeProcessMetricData() {
    }

    public KnowledgeProcessMetricData(KnowledgeProcessMetric processMetric) {
        this.name = processMetric.getName();
        this.processStarted = processMetric.getProcessStarted();
        this.processCompleted = processMetric.getProcessCompleted();
        this.processNodeTriggered = processMetric.getProcessNodeTriggered();
    }

    @XmlElement
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @XmlElement
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @XmlElement
    public Long getProcessStarted() {
        return processStarted;
    }

    public void setProcessStarted(Long processStarted) {
        this.processStarted = processStarted;
    }

    @XmlElement
    public Long getProcessCompleted() {
        return processCompleted;
    }

    public void setProcessCompleted(Long processCompleted) {
        this.processCompleted = processCompleted;
    }

    @XmlElement
    public Long getProcessNodeTriggered() {
        return processNodeTriggered;
    }

    public void setProcessNodeTriggered(Long processNodeTriggered) {
        this.processNodeTriggered = processNodeTriggered;
    }

}
