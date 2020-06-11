package br.org.pucsc.meusprocessos.service;

import java.util.List;

import br.org.pucsc.meusprocessos.model.Process;

public interface ProcessService {
	
	public List<Process> getAllProcesss();
	
	public Process getProcessById(Long id);
	
	public Process getProcessByName(String name);
		
	public void deleteProcess(Long id);
	
	public Process createProcess(String name, String observation, Long idCustomer, Long idEmployee);

	public Process updateProcess(Long id, String name, String observation, Long idCustomer, Long idEmployee);
}
