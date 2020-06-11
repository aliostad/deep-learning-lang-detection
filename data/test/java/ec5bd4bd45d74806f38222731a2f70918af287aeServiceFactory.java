package com.ntnu.eit.common.service;

public class ServiceFactory {

	//Instance
	private static ServiceFactory instance;
	
	//Services
	private PatientService pasientService;
	private DepartmentService departmentService;
	private TaskService taskService;
	private MedicineService medicineService;
	private MedicineFormService medicineFormService;
	private AuthenticationService authenticationService;
	
	public PatientService getPatientService(){
		if(pasientService == null){
			pasientService = new PatientServiceTestImpl();
		}
		return pasientService;
	}
	
	public DepartmentService getDepartmentService(){
		if(departmentService == null){
			departmentService = new DepartmentServiceTestImpl();
		}
		return departmentService;
	}
	
	public TaskService getTaskService(){
		if(taskService == null){
			taskService = new TaskServiceTestImpl();
		}
		return taskService;
	}
	
	public MedicineService getMedicineService(){
		if(medicineService == null){
			medicineService = new MedicineServiceTestImpl();
		}
		return medicineService;
	}
	
	public MedicineFormService getMedicineFormService(){
		if(medicineFormService == null){
			medicineFormService = new MedicineFormServiceTestImpl();
		}
		return medicineFormService;
	}
	
	public AuthenticationService getAuthenticationService(){
		if(authenticationService == null){
			authenticationService = new AuthenticationServiceTestImpl(); 
		}
		
		return authenticationService;
	}
	
	public static ServiceFactory getInstance(){
		if(instance == null){
			instance = new ServiceFactory();
		}
		return instance;
	}
	
	public static void finallize(){
		instance = null;
	}
}