package by.ittc.project.service;

import java.util.List;

import by.ittc.project.database.dao.ServiceDAO;
import by.ittc.project.database.dao.ServiceDAOImpl;
import by.ittc.project.model.Service;

public class ServiceService {

	private ServiceDAO serviceDAO = new ServiceDAOImpl();

	public ServiceDAO getServiceDAO() {
		return serviceDAO;
	}

	public void setServiceDAO(ServiceDAO serviceDAO) {
		this.serviceDAO = serviceDAO;
	}

	public void addService(final Service service) {
		serviceDAO.addService(service);
	}

	public Service getServiceById(final int id) {
		return serviceDAO.getServiceById(id);
	}

	public List<Service> getServicesList() {
		return serviceDAO.getServicesList();
	}

	public List<Service> getServicesByAccountId(int accountId) {
		return serviceDAO.getServicesByAccountId(accountId);
	}

	public void updateService(final Service service) {
		serviceDAO.updateService(service);
	}

	public void deleteService(final Service service) {
		serviceDAO.deleteService(service);
	}

}
