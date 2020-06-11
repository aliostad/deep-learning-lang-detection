package action;

import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.springframework.stereotype.Controller;

import Model.Service;
import service.IServiceService;

import javax.annotation.Resource;

@Action (value="serviceAction",results={
		@Result(name="list",type="redirectAction",location="serviceAssign!list"),
		@Result(name="suc",location="/index.jsp")
		})
		
@Controller
public class ServiceAction {

	
	@Resource(name = "serviceService")
	private IServiceService serviceService;
	
	
	private Service service;
	
	private String serviceId;
	
	
	public Service getService() {
		return service;
	}
	public void setService(Service service) {
		this.service = service;
	}
	public String getServiceId() {
		return serviceId;
	}
	public void setServiceId(String serviceId) {
		this.serviceId = serviceId;
	}
	
	
	
	public String add(){
		serviceService.addoredit(service);
		return "list";
	}
	public String edit(){
		serviceService.addoredit(service);
		return "list";
	}
	public String delete(){
		serviceService.deletebyid(Integer.parseInt(serviceId));
		return "list";
	}
}
