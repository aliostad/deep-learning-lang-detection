package se.coredev.sdj.service;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import se.coredev.sdj.model.Employee;
import se.coredev.sdj.repository.AddressRepository;
import se.coredev.sdj.repository.EmployeeRepository;


@Service
public class EmployeeService {

	private EmployeeRepository employeeRepository;
	private AddressRepository addressRepository;

	@Autowired
	public EmployeeService(EmployeeRepository employeeRepository, AddressRepository addressRepository) {
		this.employeeRepository = employeeRepository;
		this.addressRepository = addressRepository;
	}

	@Transactional
	public Employee save(Employee employee) {
		addressRepository.save(employee.getAddress());
		return employeeRepository.save(employee);
	}
}