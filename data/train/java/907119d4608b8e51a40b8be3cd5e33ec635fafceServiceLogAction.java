package repository.actions.log;

import java.util.LinkedList;
import java.util.List;

import com.opensymphony.xwork2.ActionContext;

import cn.org.act.sdp.repository.cloud.entity.ServiceLogTBean;
import repository.actions.BaseAction;
import repository.entity.ServiceLogBean;
import repository.service.ServiceLogService;
import repository.service.ServiceService;

public class ServiceLogAction extends BaseAction {

	private static final long serialVersionUID = -8700719102424555819L;

	private List<ServiceLogTBean> serviceLogTList;
	private List<ServiceLogBean> serviceLogList;

	private ServiceService serviceService;
	private ServiceLogService serviceLogService;

	public String getServiceLog() throws Exception {
		String userName = null;
		ServiceLogBean serviceLogBean;
		ActionContext ctx = ActionContext.getContext();
		userName = (String) ctx.getSession().get("userName");
		serviceLogTList = serviceLogService.get(userName);
		serviceLogList = new LinkedList<ServiceLogBean>();
		for (int i = 0; i < serviceLogTList.size(); i++) {
			serviceLogBean = new ServiceLogBean();
			serviceLogBean.setServiceId(serviceLogTList.get(i).getServiceId());
			serviceLogBean.setServiceName(serviceService.getById(new Long(1),
					serviceLogTList.get(i).getServiceId()).getName());
			serviceLogBean.setUserName(serviceLogTList.get(i).getUserName());
			serviceLogBean.setTimestamp(serviceLogTList.get(i).getTimestamp());
			serviceLogList.add(serviceLogBean);
		}
		return SUCCESS;
	}

	public List<ServiceLogTBean> getServiceLogTList() {
		return serviceLogTList;
	}

	public void setServiceLogTList(List<ServiceLogTBean> serviceLogTList) {
		this.serviceLogTList = serviceLogTList;
	}

	public List<ServiceLogBean> getServiceLogList() {
		return serviceLogList;
	}

	public void setServiceLogList(List<ServiceLogBean> serviceLogList) {
		this.serviceLogList = serviceLogList;
	}

	public ServiceService getServiceService() {
		return serviceService;
	}

	public void setServiceService(ServiceService serviceService) {
		this.serviceService = serviceService;
	}

	public ServiceLogService getServiceLogService() {
		return serviceLogService;
	}

	public void setServiceLogService(ServiceLogService serviceLogService) {
		this.serviceLogService = serviceLogService;
	}
}
