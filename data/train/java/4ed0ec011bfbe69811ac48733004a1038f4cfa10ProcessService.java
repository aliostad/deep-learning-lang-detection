package org.example.services;

import java.util.List;
import org.example.entities.MainProcess;
import org.granite.messaging.service.annotations.RemoteDestination;


@RemoteDestination
public interface ProcessService {

    public void addProcess(MainProcess mainProcess);
    
    public MainProcess updateProcess(MainProcess mainProcess);
    
    public MainProcess getProcessById(Long processId);
    
    public List<MainProcess> getProcesses();
    
    public void deleteProcess(MainProcess mainProcess);
}
