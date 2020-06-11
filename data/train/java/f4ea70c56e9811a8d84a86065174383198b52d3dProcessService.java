/*!
* \File: ProcessService.java 
* \Author: Quaglio Davide <quaglio.davide@gmail.com> 
* \Date: 2014-04-22 
* \LastModified: 2014-09-10
* \Class: ProcessService
* \Package: com.sirius.sequenziatore.server.service
* \Brief: gestione dei processi
* */
package com.sirius.sequenziatore.server.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sirius.sequenziatore.server.controller.utilities.ProcessWrapper;
import com.sirius.sequenziatore.server.model.Block;
import com.sirius.sequenziatore.server.model.Process;
import com.sirius.sequenziatore.server.model.ProcessDao;
import com.sirius.sequenziatore.server.model.User;
import com.sirius.sequenziatore.server.model.UserDao;

@Service
public class ProcessService {
	@Autowired
	ProcessDao processDao;
	@Autowired
	UserDao userDao;
	public boolean createProcess(ProcessWrapper processWrapper){
		Process process;
		List<Block> blocks;
		process=processWrapper.getProcess();//recupero il processo
		blocks=processWrapper.getBlockList();//recupero la lista di blocchi
		boolean result=processDao.insertProcess(process, blocks);//inserisco nel database il processo e lo salvo
		return result;			
	}
	public List<Process> getProcessList(){
		List<Process> processList=new ArrayList<Process>();
		processList=processDao.getAllProcess();
		return processList;
	}
	public List<User> getUserList(int processId) {
		List<User> userList=new ArrayList<User>();
		userList=userDao.getUserByProcess(processId);
		return userList;
	}
	public boolean terminateProcess(int processId) {
		Process process;
		process=processDao.getProcess(processId);
		process.setTerminated(true);
		boolean result=processDao.updateProcess(process);
		return result;
	}
	public boolean deleteProcess(int processId) {
		Process process;
		process=processDao.getProcess(processId);
		process.setEliminated(true);
		boolean result=processDao.updateProcess(process);
		return result;
	}
	
}
