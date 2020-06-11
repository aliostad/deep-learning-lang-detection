package se.coredev.sdj.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import se.coredev.sdj.model.Employee;
import se.coredev.sdj.repository.EmployeeRepository;

@Service
public class EmployeeService {

	@Autowired
	private EmployeeRepository repository;

	@Autowired
	public EmployeeService(EmployeeRepository repository){
		this.repository = repository;
	}
	
	public Employee save(Employee employee){
		return repository.save(employee);
	}
}
