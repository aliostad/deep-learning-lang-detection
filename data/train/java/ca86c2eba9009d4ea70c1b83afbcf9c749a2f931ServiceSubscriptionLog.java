package repository.actions.log;

import java.util.LinkedList;
import java.util.List;

import com.opensymphony.xwork2.ActionContext;

import cn.org.act.sdp.repository.cloud.entity.ServiceSubscriptionTBean;

import repository.actions.BaseAction;
import repository.entity.ServiceSubscriptionBean;
import repository.service.ServiceService;
import repository.service.ServiceSubscriptionService;

public class ServiceSubscriptionLog extends BaseAction {

	private static final long serialVersionUID = 3458926851613111776L;

	private List<ServiceSubscriptionTBean> ServiceSubscriptionTList;
	private List<ServiceSubscriptionBean> ServiceSubscriptionList;

	private ServiceService serviceService;
	private ServiceSubscriptionService serviceSubscriptionService;

	public String getServiceSubscriptionLog() throws Exception {
		String userName = null;
		ServiceSubscriptionBean serviceSubscriptionBean;
		ActionContext ctx = ActionContext.getContext();
		userName = (String) ctx.getSession().get("userName");
		ServiceSubscriptionTList = serviceSubscriptionService
				.getByName(userName);
		ServiceSubscriptionList = new LinkedList<ServiceSubscriptionBean>();
		for (int i = 0; i < ServiceSubscriptionTList.size(); i++) {
			serviceSubscriptionBean = new ServiceSubscriptionBean();
			serviceSubscriptionBean.setServiceId(ServiceSubscriptionTList
					.get(i).getServiceId());
			serviceSubscriptionBean.setUserName(ServiceSubscriptionTList.get(i)
					.getUserName());
			serviceSubscriptionBean.setServiceName(serviceService
					.getById(new Long(1),
							ServiceSubscriptionTList.get(i).getServiceId())
					.getName());
			ServiceSubscriptionList.add(serviceSubscriptionBean);
		}
		return SUCCESS;
	}

	public List<ServiceSubscriptionTBean> getServiceSubscriptionTList() {
		return ServiceSubscriptionTList;
	}

	public void setServiceSubscriptionTList(
			List<ServiceSubscriptionTBean> serviceSubscriptionTList) {
		ServiceSubscriptionTList = serviceSubscriptionTList;
	}

	public List<ServiceSubscriptionBean> getServiceSubscriptionList() {
		return ServiceSubscriptionList;
	}

	public void setServiceSubscriptionList(
			List<ServiceSubscriptionBean> serviceSubscriptionList) {
		ServiceSubscriptionList = serviceSubscriptionList;
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
