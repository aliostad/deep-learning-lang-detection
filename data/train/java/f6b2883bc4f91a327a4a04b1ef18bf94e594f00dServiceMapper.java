package columbarium.dao.mybatis.mappers;

import java.util.List;

import columbarium.model.Service;
import columbarium.model.ServiceRequirement;

public interface ServiceMapper {

	public Integer saveService(Service service);
	public Service getService(Service service);
	public void updateService(Service service);
	public void deactivateService(Service service);
	
	public void saveRequirement(ServiceRequirement serviceRequirement);
	public void removeRequirementFromService(ServiceRequirement serviceRequirement);
	public void addRequirementFromService(ServiceRequirement serviceRequirement);
	public Integer checkIfExistingRequirementInService(ServiceRequirement serviceRequirement);	
	
	public Integer checkIfExisting(Service service);
	
	public List<Service>getAllService();
	public int countAllService();
	public List<Service>searchServiceList(Service service);
	
	public int getLastServiceId();
	public int getServiceId(Service service);
	
}
