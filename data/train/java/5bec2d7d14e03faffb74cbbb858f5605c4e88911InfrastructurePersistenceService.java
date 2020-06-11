/**
 * 
 */
package gr.ekt.cerif.services.infrastructure;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * Persistence service for CERIF 2nd Level Entities.
 * 
 */
@Component
public class InfrastructurePersistenceService {
	
	/**
	 * The equipment repository.
	 */
	@Autowired
	private EquipmentRepository equipmentRepository;
	
	/**
	 * The facility repository.
	 */
	@Autowired
	private FacilityRepository facilityRepository;

	/**
	 * The service repository.
	 */
	@Autowired
	private ServiceRepository serviceRepository;
		
	
	/**
	 * @return the equipmentRepository
	 */
	public EquipmentRepository getEquipmentRepository() {
		return equipmentRepository;
	}

	/**
	 * @return the facilityRepository
	 */
	public FacilityRepository getFacilityRepository() {
		return facilityRepository;
	}

	/**
	 * @return the serviceRepository
	 */
	public ServiceRepository getServiceRepository() {
		return serviceRepository;
	}

	
	
}
