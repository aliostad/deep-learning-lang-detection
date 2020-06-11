package org.kuali.student.r2.core.process.context;

import org.kuali.student.r2.core.process.evaluator.ProcessEvaluator;

public class SubProcessCheckContext extends CheckContext {

    private String atpKey;
    private String studentId;
    private ProcessEvaluator processEvaluator;
    private ProcessContext processContext;
    
    public SubProcessCheckContext() {
    }

    public String getAtpKey() {
        return atpKey;
    }

    public void setAtpKey(String atpKey) {
        this.atpKey = atpKey;
    }

    public String getStudentId() {
        return studentId;
    }

    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }

    public ProcessEvaluator getProcessEvaluator() {
        return processEvaluator;
    }

    public void setProcessEvaluator(ProcessEvaluator processEvaluator) {
        this.processEvaluator = processEvaluator;
    }

    public ProcessContext getProcessContext() {
        return processContext;
    }

    public void setProcessContext(ProcessContext processContext) {
        this.processContext = processContext;
    }
    
}
