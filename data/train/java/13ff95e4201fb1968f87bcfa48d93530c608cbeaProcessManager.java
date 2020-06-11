package com.jiaxing.manager;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.jiaxing.global.Global;
import com.jiaxing.models.Host;
import com.jiaxing.network.SlaveDaemon;
import com.jiaxing.process.MigratableProcess;

public class ProcessManager {
	//a map to map between process name and the actual process
	private  Map<String, MigratableProcess> processMap = new HashMap<String, MigratableProcess>();
	

	
	public MigratableProcess launch(String className, String[] args) throws InstantiationException, IllegalAccessException, ClassNotFoundException, SecurityException, NoSuchMethodException, IllegalArgumentException, InvocationTargetException{
		Constructor constructor = Class.forName(className).getDeclaredConstructor(String[].class);
		MigratableProcess process = (MigratableProcess) constructor.newInstance(new Object[]{args});
		processMap.put(process.getUid(), process);
		new Thread(process).start();
		return process;
	}
	
	public MigratableProcess removeProcess(String processName){
		MigratableProcess process = null;
		if(processMap.containsKey(processName)){
			process = processMap.get(processName);
			process.migrate();
			processMap.remove(processName);
		}
		return process;
	}
	
	public boolean addProcess(MigratableProcess process){
		if(!processMap.containsKey(process.getUid())){
			processMap.put(process.getUid(), process);
			process.resume();
			//start process again
			new Thread(process).start();
			return true;
		}
		return false;
	}
	
	public List<String> getAllProcesses(){
		Set<String> keySet = Global.processManager.processMap.keySet();
		return new ArrayList<String>(keySet);
	}
}
