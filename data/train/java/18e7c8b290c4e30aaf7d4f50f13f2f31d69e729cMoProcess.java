package com.laconic.inv.stockout.component;

public class MoProcess {

    private String processId;
    private String processCode;
    private String processName;
    private String processDescription;
    private String processDepartment;
    private int processRowNo;
    private String processSequence;
    protected boolean byProcess = true;

    public MoProcess() {
   
    }
    //set

    public void setProcessCode(String processCode) {
        this.processCode = processCode;
    }

    public void setProcessDepartment(String processDepartment) {
        this.processDepartment = processDepartment;
    }

    public void setProcessDescription(String processDescription) {
        this.processDescription = processDescription;
    }

    public void setProcessId(String processId) {
        this.processId = processId;
    }

    public void setProcessName(String processName) {
        this.processName = processName;
    }


    public void setProcessSequence(String processSequence) {
        this.processSequence = processSequence;
    }
    //get

    public String getProcessCode() {
        return processCode;
    }

    public String getProcessDepartment() {
        return processDepartment;
    }

    public String getProcessDescription() {
        return processDescription;
    }

    public String getProcessId() {
        return this.processId;
    }

    public String getProcessName() {
        return processName;
    }

//    public String getKey() {
//        return this.processId + this.processSequence;
//        // return this.processId;
//    }


    public String getProcessSequence() {
        return processSequence;
    }

    public int getProcessRowNo() {
        return processRowNo;
    }

    public void setProcessRowNo(int processRowNo) {
        this.processRowNo = processRowNo;
    }

    public boolean isByProcess() {
        return byProcess;
    }

    public void setByProcess(boolean byProcess) {
        this.byProcess = byProcess;
    }
    // HtmlInterface

//    public String getHTMLSelectButton() {
//        return "<img src=/laconic/img/yes.gif border=0 alt='Select' onClick=dispatchCallBackWindow('select-ProcessList-" + this.getKey() + "','ture')>";
//    }
//
//    public String getHtmlItem() {
//        StringBuffer list = new StringBuffer();
//        list.append("[");
//        //list.append("\"").append("<img src=/laconic/img/yes.gif border=0 alt='Select' onClick=dispatchCallBackWindow('select-Process-").append(this.getKey()).append("')>").append("\",");
//        list.append("\"" + getHTMLSelectButton() + "\",");
//        list.append("\"").append(this.getProcessId()).append("\",");
//        list.append("\"").append(this.getProcessCode()).append("\",");
//        list.append("\"").append(this.getProcessName()).append("\",");
//        list.append("\"").append(this.getProcessSequence()).append("\",");
//        list.append("\"").append(this.getProcessDescription()).append("\"");
//        list.append("]");
//        return list.toString();
//    }



}
