package edu.cs.ubbcluj.ro.repository.beans;

import javax.ejb.Stateless;

import edu.cs.ubbcluj.ro.model.Complaint;
import edu.cs.ubbcluj.ro.repository.ComplaintRepository;
import edu.cs.ubbcluj.ro.repository.RepositoryException;

@Stateless(name = "ComplaintRepository", mappedName = "ComplaintRepository")
public class ComplaintRepositoryBean extends BaseRepositoryBean<Complaint, Integer>
		implements ComplaintRepository {

	public ComplaintRepositoryBean() {
		super(Complaint.class);
	}

	@Override
	public Complaint getById(Integer id) throws RepositoryException {
		return this.getEntityManager().find(Complaint.class, id);

	}

}
