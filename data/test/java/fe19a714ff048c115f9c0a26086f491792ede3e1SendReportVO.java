package com.wcs.tih.interaction.controller.vo;

import java.io.Serializable;

import com.wcs.common.controller.helper.IdModel;

public class SendReportVO  extends IdModel implements Serializable {

    private static final long serialVersionUID = 1L;
    
    private String processUser;
    private String processMethod;
    private String processTime;
    private String processOpinion;
    private String processPost;
    
    public SendReportVO(String processUser,String processMethod,String processTime,String processOpinion,String processPost){
        this.processUser=processUser;
        this.processMethod=processMethod;
        this.processTime=processTime;
        this.processOpinion=processOpinion;
        this.processPost=processPost;
    }
    
    private String reportId;
    private String reportName;
    
    public SendReportVO(Long id,String reportId,String reportName){
    	setId(id);
    	this.reportId=reportId;
    	this.reportName=reportName;
    }
    
    public SendReportVO(){
        
    }
    
    public String getProcessUser() {
        return processUser;
    }
    public void setProcessUser(String processUser) {
        this.processUser = processUser;
    }
    public String getProcessMethod() {
        return processMethod;
    }
    public void setProcessMethod(String processMethod) {
        this.processMethod = processMethod;
    }
    public String getProcessTime() {
        return processTime;
    }
    public void setProcessTime(String processTime) {
        this.processTime = processTime;
    }
    public String getProcessOpinion() {
        return processOpinion;
    }
    public void setProcessOpinion(String processOpinion) {
        this.processOpinion = processOpinion;
    }

    public String getProcessPost() {
        return processPost;
    }

    public void setProcessPost(String processPost) {
        this.processPost = processPost;
    }

	public String getReportId() {
		return reportId;
	}

	public void setReportId(String reportId) {
		this.reportId = reportId;
	}

	public String getReportName() {
		return reportName;
	}

	public void setReportName(String reportName) {
		this.reportName = reportName;
	}
    
}
