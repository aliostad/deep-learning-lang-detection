/**
 * 
 */
package org.gridchem.service.stub;

import org.apache.axis2.AxisFault;
import org.gridchem.service.stub.file.*;
import org.gridchem.service.stub.job.*;
import org.gridchem.service.stub.notification.*;
import org.gridchem.service.stub.project.*;
import org.gridchem.service.stub.resource.ResourceServiceStub;
import org.gridchem.service.stub.session.*;
import org.gridchem.service.stub.software.*;
import org.gridchem.service.stub.user.*;

/**
 * @author dooley
 *
 */
public class GMSClient {
	
	private String serviceRoot = "http://localhost:8080/axis2/services";
	
	private FileServiceStub fileService;
	private JobServiceStub jobService;
	private NotificationServiceStub notificationService;
	private ProjectServiceStub projectService;
	private ResourceServiceStub resourceService;
	private SessionServiceStub sessionService;
	private SoftwareServiceStub softwareService;
	private UserServiceStub userService;

	
	public GMSClient(String serviceRoot) {
		this.serviceRoot = serviceRoot;
	}
	
	public FileServiceStub getFileService() throws AxisFault {
		if (fileService == null) {
			fileService = new FileServiceStub(serviceRoot + "/FileService.FileServiceHttpSoap12Endpoint/");
		}
		
		return fileService;
	}
	
	public JobServiceStub getJobService() throws AxisFault {
		if (jobService == null) {
			jobService = new JobServiceStub(serviceRoot + "/JobService.JobServiceHttpSoap12Endpoint/");
		}
		
		return jobService;
	}
	
	public NotificationServiceStub getNotificationService() throws AxisFault {
		if (notificationService == null) {
			notificationService = new NotificationServiceStub(serviceRoot + "/JobService.JobServiceHttpSoap12Endpoint/");
		}
		
		return notificationService;
	}
	
	public ProjectServiceStub getProjectService() throws AxisFault {
		if (projectService == null) {
			projectService = new ProjectServiceStub(serviceRoot + "/ProjectService.ProjectServiceHttpSoap12Endpoint/");
		}
		
		return projectService;
	}
	
	public ResourceServiceStub getResourceService() throws AxisFault {
		if (resourceService == null) {
			resourceService = new ResourceServiceStub(serviceRoot + "/ResourceService.ResourceServiceHttpSoap12Endpoint/");
		}
		
		return resourceService;
	}
	
	public SessionServiceStub getSessionService() throws AxisFault {
		if (sessionService == null) {
			sessionService = new SessionServiceStub(serviceRoot + "/SessionService.SessionServiceHttpSoap12Endpoint/");
		}
		
		return sessionService;
	}
	
	public SoftwareServiceStub getSoftwareService() throws AxisFault {
		if (softwareService == null) {
			softwareService = new SoftwareServiceStub(serviceRoot + "/SoftwareService.SoftwareServiceHttpSoap12Endpoint/");
		}
		
		return softwareService;
	}
	
	public UserServiceStub getUserService() throws AxisFault {
		if (userService == null) {
			userService = new UserServiceStub(serviceRoot + "/UserService.UserServiceHttpSoap12Endpoint/");
		}
		
		return userService;
	}
}
