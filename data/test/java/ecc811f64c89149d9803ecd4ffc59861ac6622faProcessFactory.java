package to.duly.factory;

import java.util.ArrayList;
import java.util.Collection;
import java.util.concurrent.ConcurrentHashMap;

import to.duly.part.Process;
import to.duly.part.TypeChange;

import com.google.gson.Gson;

public class ProcessFactory extends BasePartFactory {

	private static ProcessFactory fInstance = null;
	public static ProcessFactory getInstance() {
		if(fInstance == null) {
			fInstance = new ProcessFactory();
		}
		return fInstance;
	}
	private ProcessFactory() {
		super();
		fDataFileName = this.getClass().getName();
	}
	
	@Override
	public Process fromJSOM(String part) {
        Gson gson = new Gson();
        return gson.fromJson(part, Process.class);
	}
	
	private ConcurrentHashMap<String, Collection<Process>> creatorMap = new ConcurrentHashMap<String, Collection<Process>>(256);
	@SuppressWarnings("unchecked")
	public Collection<Process> queryProcess(String process_creator) {
		if(process_creator == null) {
			return (Collection<Process>) this.getAll();
		} else {
			if(!creatorMap.containsKey(process_creator)) {
				Collection<Process> processes = new ArrayList<Process>();
				for(Process process : (Collection<Process>)this.getAll()) {
					if(process_creator.equals(process.ProcessCreator)) {
						processes.add(process);
					}
				}
				creatorMap.put(process_creator, processes);
			} 
			return creatorMap.get(process_creator);
		}
	}
	public Process newProcess(String name, String creator) throws Exception {
		Process process = new Process();
		process.ID = newID();
		process.Name = name;
		process.Statues = TypeChange.NEW;
		process.ProcessCreator = creator;
		process.Attributes = new ConcurrentHashMap<String, Object>();
		return process;
	}
	public String saveProcess(Process process) {
		try {
			putPart(process);
			if(creatorMap.containsKey(process.ProcessCreator)) {
				Collection<Process> processes = creatorMap.get(process.ProcessCreator);
				if(! processes.contains(process)) {
					processes.add(process);
				}
			}
			return String.valueOf(process.ID);
		} catch (Exception e) {
			return e.getMessage();
		}
	}
	public String removeProcess(long id) {
		Process process = (Process) getPart(id);
		if(process != null) {
			process.IsDelete = true;
			if(creatorMap.containsKey(process.ProcessCreator)) {
				Collection<Process> processes = creatorMap.get(process.ProcessCreator);
				if(! processes.contains(process)) {
					processes.remove(process);
				}
			}
			return String.valueOf(process.ID);
		}
		return "";
	}
}
