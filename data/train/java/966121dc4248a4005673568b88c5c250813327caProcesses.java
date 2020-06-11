package org.gegma.cache;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

import org.gegma.GegmaProcess;

/**
 * Container class to cache running processes
 * 
 * @author levan
 * 
 */
public class Processes {

    private static final ConcurrentMap<Long, GegmaProcess> PROCESS = new ConcurrentHashMap<Long, GegmaProcess>();

    public GegmaProcess getProcess(Long processId) {

	return PROCESS.get(processId);
    }

    public void cacheProcess(GegmaProcess process) {

	PROCESS.putIfAbsent(process.getProcessId(), process);
    }
}
