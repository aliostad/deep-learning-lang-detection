package healthwatcher.data.factories;

import healthwatcher.data.IComplaintRepository;
import healthwatcher.data.IDiseaseRepository;
import healthwatcher.data.IEmployeeRepository;
import healthwatcher.data.IHealthUnitRepository;
import healthwatcher.data.ISpecialityRepository;
import healthwatcher.data.ISymptomRepository;

/**
 * Defines methods for repository factories
 */
public abstract class AbstractRepositoryFactory {
	
	public abstract IComplaintRepository createComplaintRepository();
	
	public abstract IHealthUnitRepository createHealthUnitRepository();
	
	public abstract ISpecialityRepository createMedicalSpecialityRepository();
	
	public abstract IDiseaseRepository createDiseaseRepository();
	
	public abstract IEmployeeRepository createEmployeeRepository();
	
	public abstract ISymptomRepository createSymptomRepository();
}
