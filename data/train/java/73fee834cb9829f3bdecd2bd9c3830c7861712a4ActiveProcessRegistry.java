package com.rogers.dbloader.lifecycle;

import java.util.HashSet;
import java.util.Set;

/**
 * Created by David Hildebrandt on 2015-08-03.
 */
public class ActiveProcessRegistry {

    Set<String> processSet = new HashSet<String>();

    private static ActiveProcessRegistry instance = new ActiveProcessRegistry();

    public static ActiveProcessRegistry getInstance() {
        return instance;
    }

    private ActiveProcessRegistry() {
    }

    public synchronized void registerActiveProcess(String processId) {
        processSet.add(processId);
    }

    public synchronized void deregisterActiveProcess(String processId) {
        processSet.remove(processId);
    }

    public synchronized int getNumberOfActiveProcesses() {
        return processSet.size();
    }

    public Set<String> getActiveProcessSet() {
        return processSet;
    }
}
