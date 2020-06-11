package com.ttu.roman.service.serviceorder;

import com.ttu.roman.dao.service.*;
import com.ttu.roman.form.deviceservice.DeviceServiceActionFormEdit;
import com.ttu.roman.form.deviceservice.ServicePartForm;
import com.ttu.roman.model.service.ServiceAction;
import com.ttu.roman.model.service.ServiceDevice;
import com.ttu.roman.model.service.ServicePart;
import com.ttu.roman.model.user.EmployeeUserAccount;
import com.ttu.roman.service.userlogin.UserAccountUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigInteger;
import java.sql.Timestamp;

@Service
public class ServiceOrderActionService {

    @Autowired
    ServiceTypeDAO serviceTypeDAO;

    @Autowired
    ServiceActionStatusTypeDAO serviceActionStatusTypeDAO;

    @Autowired
    ServiceActionDAO serviceActionDAO;

    @Autowired
    ServiceDeviceDAO serviceDeviceDAO;

    @Autowired
    ServicePartDAO servicePartDAO;

    public ServiceDevice saveNewServiceAction(DeviceServiceActionFormEdit newFormServiceAction) {
        ServiceAction serviceAction = new ServiceAction();
        ServiceDevice serviceDevice = serviceDeviceDAO.find(newFormServiceAction.getDeviceInService());

        serviceAction.setActionDescription(newFormServiceAction.getActionDescription());
        serviceAction.setServiceType(serviceTypeDAO.find(newFormServiceAction.getServiceType()));
        serviceAction.setServiceActionStatusType(serviceActionStatusTypeDAO.find(newFormServiceAction.getServiceActionStatusType()));
        serviceAction.setServiceAmount(new BigInteger(newFormServiceAction.getServiceAmount()));
        serviceAction.setPrice(new BigInteger(newFormServiceAction.getPrice()));
        serviceAction.setPrice(new BigInteger(newFormServiceAction.getPrice()));
        serviceAction.setServiceDevice(serviceDevice);
        serviceAction.setServiceOrder(serviceDevice.getServiceOrder());
        serviceAction.setCreated(new Timestamp(System.currentTimeMillis()));

        serviceAction.setCreatedBy(((EmployeeUserAccount) UserAccountUtil.getCurrentUser()).getEmployee().getEmployee());

        serviceActionDAO.create(serviceAction);
        serviceDevice = serviceDeviceDAO.find(newFormServiceAction.getDeviceInService());
        return serviceDevice;
    }

    public void saveServicePart(ServicePartForm servicePartForm, ServiceDevice serviceDevice) {
        ServicePart servicePart = new ServicePart();
        servicePart.setPartName(servicePartForm.getPartName());
        servicePart.setSerialNo(servicePartForm.getSerialNo());
        servicePart.setPartPrice(new BigInteger(servicePartForm.getPartPrice()));
        servicePart.setPartCount(new Integer(servicePartForm.getPartCount()));
        servicePart.setServiceDevice(serviceDevice);
        servicePart.setServiceOrder(serviceDevice.getServiceOrder());
        servicePart.setCreated(new Timestamp(System.currentTimeMillis()));
        servicePart.setCreatedBy(((EmployeeUserAccount) UserAccountUtil.getCurrentUser()).getEmployee().getEmployee());

        servicePartDAO.create(servicePart);
    }

    public void updateServicePart(ServicePartForm servicePartForm, ServicePart servicePart) {
        servicePart.setPartCount(new Integer(servicePartForm.getPartCount()));
        servicePart.setPartPrice(new BigInteger(servicePartForm.getPartPrice()));
        servicePart.setPartName(servicePartForm.getPartName());
        servicePart.setSerialNo(servicePartForm.getSerialNo());

        servicePartDAO.update(servicePart);
    }

    public void updateServiceAction(DeviceServiceActionFormEdit deviceServiceActionFormEdit, ServiceAction serviceAction) {
        serviceAction.setPrice(new BigInteger(deviceServiceActionFormEdit.getPrice()));
        serviceAction.setServiceAmount(new BigInteger(deviceServiceActionFormEdit.getServiceAmount()));
        serviceAction.setActionDescription(deviceServiceActionFormEdit.getActionDescription());
        serviceAction.setServiceActionStatusType(serviceActionStatusTypeDAO.find(deviceServiceActionFormEdit.getServiceActionStatusType()));
        serviceAction.setServiceType(serviceTypeDAO.find(deviceServiceActionFormEdit.getServiceType()));

        serviceActionDAO.update(serviceAction);
    }
}
