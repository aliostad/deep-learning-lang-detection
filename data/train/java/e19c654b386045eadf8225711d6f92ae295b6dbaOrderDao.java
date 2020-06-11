package ee.iapb61.idu0200.dao;

import java.util.List;

import ee.iapb61.idu0200.model.ServiceAction;
import ee.iapb61.idu0200.model.ServiceDevice;
import ee.iapb61.idu0200.model.ServiceDeviceStatusType;
import ee.iapb61.idu0200.model.ServiceOrder;
import ee.iapb61.idu0200.model.ServicePart;
import ee.iapb61.idu0200.model.ServiceType;

public interface OrderDao {

	ServiceOrder getOrderByReqyestId(String requestId);

	int saveOrUpdateOrder(ServiceOrder serviceOrder);

	void saveServiceDevice(ServiceDevice serviceDevice);

	void updateServiceOrder(ServiceOrder serviceOrder);

	void deleteServiceDevice(ServiceDevice serviceDevice);

	ServiceDevice getOrderServiceDeviceByDeviceId(Integer deviceId);

	List<ServiceDeviceStatusType> getServiceDeviceClassifiers();

	ServiceDeviceStatusType getServiceDeviceStatusTypeById(Integer status);

	void updateServiceDevice(ServiceDevice serviceDevice);

	void saveServicePart(ServicePart servicePart);
	
	void updateServicePart(ServicePart servicePart);

	ServicePart getServicePartById(Integer servicePartId);

	void deleteServicePart(ServicePart servicePart);

	ServiceDevice getOrderServiceDeviceByServiceDeviceId(Integer deviceId);

	ServiceType getServiceTypeById(Integer type);

	void saveServiceAction(ServiceAction serviceAction);

	ServiceAction getServiceActionById(Integer jobId);

	void updateServiceAction(ServiceAction serviceAction);

	void deleteObject(ServiceAction serviceAction);

	String deleteOrder(ServiceOrder order);
}
