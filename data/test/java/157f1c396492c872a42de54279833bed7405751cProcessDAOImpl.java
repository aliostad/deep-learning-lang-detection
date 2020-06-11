package com.espendwise.manta.dao;


import javax.persistence.EntityManager;
import javax.persistence.Query;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import com.espendwise.manta.model.data.ProcessData;
import com.espendwise.manta.util.RefCodeNames;


@Repository
public class ProcessDAOImpl extends DAOImpl implements ProcessDAO {

    private static final Logger logger = Logger.getLogger(ProcessDAOImpl.class);
    public ProcessDAOImpl() {
        this(null);
    }

    public ProcessDAOImpl(EntityManager entityManager) {
        super(entityManager);
    }

	@Override
	public ProcessData getProcessByName(String processName) {
		Query query = em.createQuery("Select object(process) from ProcessData process " +
		"where process.processName = (:processName) " +
		"and process.processTypeCd = (:processTypeCd)" );

		query.setParameter("processName", processName);
		query.setParameter("processTypeCd", RefCodeNames.PROCESS_TYPE_CD.TEMPLATE);
		
		ProcessData process = (ProcessData) query.getSingleResult();
		return process;
	}

}
