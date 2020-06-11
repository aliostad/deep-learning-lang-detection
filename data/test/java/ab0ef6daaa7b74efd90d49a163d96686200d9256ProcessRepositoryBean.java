package org.drools.process.enterprise.repository;

import java.util.List;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

@Stateless
public class ProcessRepositoryBean implements ProcessRepository {

	private @PersistenceContext EntityManager manager;
	   
	public void storeProcess(String processId, String processXML) {
		ProcessInfo processInfo = manager.find(ProcessInfo.class, processId);
		if (processInfo != null) {
			System.out.println("Overriding existing process definition " + processId);
		} else {
			processInfo = new ProcessInfo();
		}
		processInfo.setProcessXML(processId, processXML);
		manager.persist(processInfo);
		System.out.println("Stored process " + processId);
	}
	
	public ProcessInfo getProcessInfo(String processId) {
		return manager.find(ProcessInfo.class, processId);
	}
	
	public List<ProcessInfo> getProcessInfos() {
		return manager.createQuery("from ProcessInfo p").getResultList();
	}

}
