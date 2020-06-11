package sk.erni.rap.jpa.dao;

import sk.erni.rap.jpa.model.Process;
import sk.erni.rap.jpa.model.ProcessAttribute;

import javax.annotation.PostConstruct;
import javax.ejb.EJB;
import javax.ejb.Stateless;
import javax.ejb.TransactionAttribute;
import javax.ejb.TransactionAttributeType;
import javax.persistence.EntityManager;
import javax.persistence.FlushModeType;
import javax.persistence.OptimisticLockException;
import javax.persistence.PersistenceContext;

/**
 * @author rap
 */
@Stateless
public class ProcessDao {

	@PersistenceContext(name = "openjpa")
	private EntityManager entityManager;

	@EJB
	private ProcessDao self;

	@PostConstruct
	public void init() {
		entityManager.setFlushMode(FlushModeType.COMMIT);
	}

	public void save(Process process) {
		entityManager.persist(process);
	}

	@TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
	public void addProcessAttribute(Integer processId, ProcessAttribute processAttribute) {
		Process process = findById(processId);
		process.addProcessAttribute(processAttribute);
		entityManager.flush();
	}

	public void addProcessAttributeWithoutCheck(Process process, ProcessAttribute processAttribute) {
		mergeAndAdd(process, processAttribute);
	}

	public void addProcessAttributeWithCheck(Process process, ProcessAttribute processAttribute) {
		try {
			mergeAndAdd(process, processAttribute);
		} catch (OptimisticLockException ole) {
			self.addProcessAttribute(process.getId(), processAttribute);
		}
	}

	@TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
	private void mergeAndAdd(Process process, ProcessAttribute processAttribute) {
		process = entityManager.merge(process);
		process.addProcessAttribute(processAttribute);
	}

	public Process findById(Integer id) {
		return entityManager.
				createQuery("select distinct p from Process p left join fetch p.processAttributes where p.id = ?1", Process.class)
				.setParameter(1, id)
				.getSingleResult();
	}
}
