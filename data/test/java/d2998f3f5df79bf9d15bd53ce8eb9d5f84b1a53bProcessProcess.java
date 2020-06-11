package org.bungeni.trackchanges.process.schema;

import java.util.Date;

/**
 *
 * @author Ashok Hariharan
 */
public class ProcessProcess {
    private String processId ;
    private String billId;
    private Date processDate;
    private ProcessStatus processStatus;

    public static enum ProcessStatus {
        Start ("Start"),
        End ("End"),
        Discard ("Discarded");

        String procStatus;

        ProcessStatus (String pstatus) {
            this.procStatus = pstatus;
        }

        @Override
        public String toString(){
            return procStatus;
        }

    }

    public ProcessProcess (String pId, String bId, Date pDate, ProcessStatus pStatus) {
        this.processId = pId;
        this.billId = bId;
        this.processDate = pDate;
        this.processStatus = pStatus;
    }

    /**
     * @return the processId
     */
    public String getProcessId() {
        return processId;
    }

    /**
     * @param processId the processId to set
     */
    public void setProcessId(String processId) {
        this.processId = processId;
    }

    /**
     * @return the billId
     */
    public String getBillId() {
        return billId;
    }

    /**
     * @param billId the billId to set
     */
    public void setBillId(String billId) {
        this.billId = billId;
    }

    /**
     * @return the processDate
     */
    public Date getProcessDate() {
        return processDate;
    }

    /**
     * @param processDate the processDate to set
     */
    public void setProcessDate(Date processDate) {
        this.processDate = processDate;
    }

    /**
     * @return the processStatus
     */
    public ProcessStatus getProcessStatus() {
        return processStatus;
    }

    /**
     * @param processStatus the processStatus to set
     */
    public void setProcessStatus(ProcessStatus processStatus) {
        this.processStatus = processStatus;
    }

}
