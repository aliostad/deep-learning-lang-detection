package org.drools.process.audit;

import java.util.Date;

public class ProcessInstanceLog {
    
    private long processInstanceId;
    private String processId;
    private Date start;
    private Date end;
    
    ProcessInstanceLog() {
    }
    
    public ProcessInstanceLog(long processInstanceId, String processId) {
        setProcessInstanceId(processInstanceId);
        setProcessId(processId);
        setStart(new Date());
    }
    
    public long getProcessInstanceId() {
        return processInstanceId;
    }
    
    private void setProcessInstanceId(long processInstanceId) {
        this.processInstanceId = processInstanceId;
    }
    
    public String getProcessId() {
        return processId;
    }
    
    public void setProcessId(String processId) {
        this.processId = processId;
    }
    
    public Date getStart() {
        return start;
    }
    
    public void setStart(Date start) {
        this.start = start;
    }
    
    public Date getEnd() {
        return end;
    }
    
    public void setEnd(Date end) {
        this.end = end;
    }
    
    public String toString() {
        return "Process '" + processId + "' [" + processInstanceId + "]";
    }
    
}
