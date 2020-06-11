package repository.actions.service;

import cn.org.act.sdp.repository.cloud.entity.ServiceSubscriptionTBean;
import cn.org.act.sdp.repository.entity.ServiceTBean;
import repository.actions.BaseAction;
import repository.service.ServiceService;
import repository.service.ServiceSubscriptionService;

public class ServiceSubscriptionAction extends BaseAction {

	private static final long serialVersionUID = -8612864488933336792L;

	private long serviceId;
	private String msg;
	private ServiceService serviceService;
	private ServiceSubscriptionService serviceSubscriptionService;

	public String execute() throws Exception {
		String userName = (String) getSession().getAttribute("userName");
		ServiceSubscriptionTBean serviceSubscriptionBean = (ServiceSubscriptionTBean) serviceSubscriptionService
				.get(userName, serviceId);
		if (serviceSubscriptionBean != null) { //已经订阅
			msg = "You have subscript this service before.";
			return ERROR;
		} else {
			ServiceTBean bean = serviceService.getById(new Long(1), serviceId);
			if (bean == null) {
				msg = "The service not exist.";
				return ERROR;
			} else {
				msg = "Subscript the service successfully.";
				return SUCCESS;
			}
		}
	}

	public long getServiceId() {
		return serviceId;
	}

	public void setServiceId(long serviceId) {
		this.serviceId = serviceId;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	public ServiceService getServiceService() {
		return serviceService;
	}

	public void setServiceService(ServiceService serviceService) {
		this.serviceService = serviceService;
	}

	public ServiceSubscriptionService getServiceSubscriptionService() {
		return serviceSubscriptionService;
	}

	public void setServiceSubscriptionService(
			ServiceSubscriptionService serviceSubscriptionService) {
		this.serviceSubscriptionService = serviceSubscriptionService;
	}
}
