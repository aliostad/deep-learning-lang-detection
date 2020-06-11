package com.feisystems.icas.service.reference;

import java.util.List;

import com.feisystems.icas.domain.reference.ServiceCode;

public interface ServiceCodeService {
	public abstract long countAllServiceCodes();


	public abstract void deleteServiceCode(ServiceCode serviceCode);


	public abstract ServiceCode findServiceCode(Long id);
	
	public abstract ServiceCode findServiceCode(String code);
	
	public abstract List<ServiceCode> findAllServiceCodes();


	public abstract List<ServiceCode> findServiceCodeEntries(int firstResult, int maxResults);


	public abstract void saveServiceCode(ServiceCode serviceCode);


	public abstract ServiceCode updateServiceCode(ServiceCode serviceCode);
}
