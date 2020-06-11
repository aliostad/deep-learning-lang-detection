package com.managetransfer.client;
// Generated Mar 15, 2016 1:49:44 PM by Hibernate Tools 4.0.0


import java.util.HashMap;
import java.util.Map;

/**
 *          This class contains the proces mapping detail. 
 *       
 */
public class ProcessMappingDetails  implements java.io.Serializable {


     private String sourceProcessName;
     private String targetProcessName;
     private Map processMappingDetailsMap = new HashMap(0);

    public ProcessMappingDetails() {
    }

	
    public ProcessMappingDetails(String sourceProcessName, String targetProcessName) {
        this.sourceProcessName = sourceProcessName;
        this.targetProcessName = targetProcessName;
    }
    public ProcessMappingDetails(String sourceProcessName, String targetProcessName, Map processMappingDetailsMap) {
       this.sourceProcessName = sourceProcessName;
       this.targetProcessName = targetProcessName;
       this.processMappingDetailsMap = processMappingDetailsMap;
    }
   
    public String getSourceProcessName() {
        return this.sourceProcessName;
    }
    
    public void setSourceProcessName(String sourceProcessName) {
        this.sourceProcessName = sourceProcessName;
    }
    public String getTargetProcessName() {
        return this.targetProcessName;
    }
    
    public void setTargetProcessName(String targetProcessName) {
        this.targetProcessName = targetProcessName;
    }
    public Map getProcessMappingDetailsMap() {
        return this.processMappingDetailsMap;
    }
    
    public void setProcessMappingDetailsMap(Map processMappingDetailsMap) {
        this.processMappingDetailsMap = processMappingDetailsMap;
    }




}


