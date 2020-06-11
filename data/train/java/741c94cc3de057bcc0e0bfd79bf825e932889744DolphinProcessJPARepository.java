package com.yttimes.dolphin.repository;

import java.util.List;

import javax.persistence.NoResultException;

import com.yttimes.dolphin.definition.ProcessDefinition;
import com.yttimes.dolphin.support.JPARepository;

public class DolphinProcessJPARepository extends JPARepository<ProcessDefinition, Long> implements DolphinProcessRepository {

	public DolphinProcessJPARepository() {
		entityClass = ProcessDefinition.class;
	}

	public List<ProcessDefinition> getProcessListByProcessId(String processId) {
		List<ProcessDefinition> dolphinProcessList = getEntityManager().createQuery(
				"from ProcessDefinition where processId = :processId order by version desc", ProcessDefinition.class).setParameter(
				"processId", processId).getResultList();
		return dolphinProcessList;
	}

	public ProcessDefinition getProcessByVersion(String processId, double version) {
		ProcessDefinition dolphinProcess;
		try {
			dolphinProcess = getEntityManager().createQuery(
					"from ProcessDefinition where processId = :processId and version = :version", ProcessDefinition.class)
					.setParameter("processId", processId).setParameter("version", version).getSingleResult();
		} catch (NoResultException e) {
			dolphinProcess = null;
		}
		return dolphinProcess;
	}

	public List<ProcessDefinition> getAllProcessDefinitions() {
		List<ProcessDefinition> dolphinProcessList = getEntityManager()
				.createQuery("from ProcessDefinition ", ProcessDefinition.class).getResultList();
		return dolphinProcessList;
	}

	public List<ProcessDefinition> getUsedProcessDefinitions() {
		List<ProcessDefinition> dolphinProcessList = getEntityManager().createQuery(
				"from ProcessDefinition d where d.id IN (select i.processDef from ProcessInstance i)", ProcessDefinition.class)
				.getResultList();
		return dolphinProcessList;
	}

	public void save(ProcessDefinition def) {
		this.persist(def);
	}

	public ProcessDefinition getProcessDefinition(long id) {
		return refresh(findById(id));
	}

	public void delete(long id) {
		this.remove(getProcessDefinition(id));
	}

	public List<ProcessDefinition> searchProcessDefinitions(String str) {
		List<ProcessDefinition> dolphinProcessList = getEntityManager().createQuery(
				"from ProcessDefinition where processId like '%" + str + "%'", ProcessDefinition.class).getResultList();
		return dolphinProcessList;
	}

	public void removeAll() {
		 getEntityManager().createQuery("delete from ProcessDefinition").executeUpdate();
	}
}
