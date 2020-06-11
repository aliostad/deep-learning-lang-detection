package com.gsli.dr.domain.service;

import org.springframework.beans.factory.annotation.Autowired;

import com.gsli.dr.domain.entity.Contractor;
import com.gsli.dr.domain.generic.GenericEntityServiceImpl;
import com.gsli.dr.domain.generic.GenericRepository;
import com.gsli.dr.domain.repository.ContractorRepository;

public class ContractorServiceImpl extends GenericEntityServiceImpl<Contractor, Long> implements ContractorService{

	@Autowired
	private ContractorRepository contractorRepository;
	
	@Override
	public GenericRepository<Contractor, Long> getEntityRepository() {
		return getContractorRepository();
	}

	@Override
	public boolean validateEntity(Contractor paramT) {
		return true;
	}

	public ContractorRepository getContractorRepository() {
		return contractorRepository;
	}

	public void setContractorRepository(ContractorRepository contractorRepository) {
		this.contractorRepository = contractorRepository;
	}

}
