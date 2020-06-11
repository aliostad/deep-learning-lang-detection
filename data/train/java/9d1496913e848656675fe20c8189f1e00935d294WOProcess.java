package com.laconic.document.form.mfg.component;


public class WOProcess{
    
    long rowNumber;
    String processSequence;
    String processCode;
    String processName;
    String processDueDate;

    // Constructor
    public WOProcess() {
    }

    // Getter
    /**
     * @return Returns the rowNumber.
     */
    public long getRowNumber() {
        return rowNumber;
    }
    /**
     * @param rowNumber The rowNumber to set.
     */
    public void setRowNumber(long rowNumber) {
        this.rowNumber = rowNumber;
    }
    /**
     * @return Returns the processCode.
     */
    public String getProcessCode() {
        return processCode;
    }
    /**
     * @param processCode The processCode to set.
     */
    public void setProcessCode(String processCode) {
        this.processCode = processCode;
    }
    /**
     * @return Returns the processName.
     */
    public String getProcessName() {
        return processName;
    }
    /**
     * @param processName The processName to set.
     */
    public void setProcessName(String processName) {
        this.processName = processName;
    }
    /**
     * @return Returns the processSequence.
     */
    public String getProcessSequence() {
        return processSequence;
    }
    /**
     * @param processSequence The processSequence to set.
     */
    public void setProcessSequence(String processSequence) {
        this.processSequence = processSequence;
    }
    /**
     * @return Returns the processDueDate.
     */
    public String getProcessDueDate() {
        return processDueDate;
    }
    /**
     * @param processDueDate The processDueDate to set.
     */
    public void setProcessDueDate(String processDueDate) {
        this.processDueDate = processDueDate;
    }
}