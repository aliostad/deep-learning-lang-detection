package com.mySampleApplication.client.managers;


import com.mySampleApplication.client.bpmn.BpmnProcess;

import java.util.HashMap;
import java.util.Map;

public class BpmnProcessManager {

    private Map<String, BpmnProcess> processes;

    private static BpmnProcessManager instance = new BpmnProcessManager();

    public BpmnProcessManager() {
        processes = new HashMap<String, BpmnProcess>();
    }

    public static BpmnProcessManager getInstance() {
        return instance;
    }

    public void addProcess(BpmnProcess process){
        this.processes.put(process.getId(), process);
    }

    public BpmnProcess getCurrentProcess(){
        // Todo cambiar esto
        return this.processes.get("processId");
    }

    public Map<String, BpmnProcess> getProcesses() {
        return processes;
    }
}
