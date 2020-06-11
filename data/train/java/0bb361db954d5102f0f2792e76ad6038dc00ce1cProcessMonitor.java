package sushi.monitoring.bpmn;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

import sushi.process.SushiProcess;
import sushi.process.SushiProcessInstance;
import sushi.query.SushiPatternQuery;

/**
 * @author micha
 */
public class ProcessMonitor implements Serializable{
	
	private static final long serialVersionUID = 1L;
	private SushiProcess process;
	private Set<SushiPatternQuery> queries;
	private Set<ProcessInstanceMonitor> processInstanceMonitors;
	private int ID;
	private int numberOfProcessInstances;
	private float averageRuntimeMillis;

	public ProcessMonitor(SushiProcess process){
		this.process = process;
		this.queries = new HashSet<SushiPatternQuery>();
		this.processInstanceMonitors = new HashSet<ProcessInstanceMonitor>();
		this.ID = BPMNQueryMonitor.getInstance().getProcessMonitors().size();
	}
	
	public Set<SushiPatternQuery> getQueries() {
		return queries;
	}
	
	public void addQuery(SushiPatternQuery query){
		this.queries.add(query);
		for(ProcessInstanceMonitor processInstanceMonitor : processInstanceMonitors){
			processInstanceMonitor.addQuery(query);
		}
	}

	public SushiProcess getProcess() {
		return process;
	}

	public void setProcess(SushiProcess process) {
		this.process = process;
	}

	public void setQueryFinishedForProcessInstance(SushiPatternQuery query, SushiProcessInstance processInstance) {
		ProcessInstanceMonitor processInstanceMonitor = getProcessInstanceMonitorForProcessInstance(processInstance);
		processInstanceMonitor.setQueryFinished(query);
	}
	
	private ProcessInstanceMonitor getProcessInstanceMonitorForProcessInstance(SushiProcessInstance processInstance){
		for(ProcessInstanceMonitor processInstanceMonitor : processInstanceMonitors){
//			if(processInstanceMonitor.getProcessInstance().equals(processInstance)){
			/*TODO: equals auf dem Process funktioniert nicht, da gleiche Prozesse mit verschiedenen IDs als Parameter kommen können:
			 * SushiProcess.equals überschreiben?
			 * Erstmal mit ID prüfen
			 */
			if(processInstanceMonitor.getProcessInstance() != null && processInstanceMonitor.getProcessInstance().getID() == processInstance.getID()){
				return processInstanceMonitor;
			}
		}
		ProcessInstanceMonitor processInstanceMonitor = new ProcessInstanceMonitor(processInstance);
		processInstanceMonitor.addQueries(queries);
		processInstanceMonitors.add(processInstanceMonitor);
		numberOfProcessInstances = processInstanceMonitors.size();
		return processInstanceMonitor;
	}

	public ProcessInstanceStatus getProcessInstanceStatus(SushiProcessInstance processInstance) {
		ProcessInstanceMonitor processInstanceMonitor = getProcessInstanceMonitorForProcessInstance(processInstance);
		return processInstanceMonitor.getStatus();
	}

	public Set<ProcessInstanceMonitor> getProcessInstanceMonitors() {
		return processInstanceMonitors;
	}
	
	/**
	 * Returns all monitored process instances with the requested status.
	 * @param processInstanceStatus
	 * @return
	 */
	public Set<SushiProcessInstance> getProcessInstances(ProcessInstanceStatus processInstanceStatus){
		Set<SushiProcessInstance> processInstances = new HashSet<SushiProcessInstance>();
		for(ProcessInstanceMonitor monitor : processInstanceMonitors){
			if(monitor.getStatus().equals(processInstanceStatus)){
				processInstances.add(monitor.getProcessInstance());
			}
		}
		return processInstances;
	}

	public int getID() {
		return ID;
	}

	public int getNumberOfProcessInstances() {
		return numberOfProcessInstances;
	}

	public float getAverageRuntimeMillis() {
		float sum = 0;
		for(ProcessInstanceMonitor processInstanceMonitor : processInstanceMonitors){
			sum += processInstanceMonitor.getEndTime().getTime() - processInstanceMonitor.getStartTime().getTime();
		}
		averageRuntimeMillis = sum / processInstanceMonitors.size();
		return averageRuntimeMillis;
	}
	
	public float getAverageRuntimeForQuery(SushiPatternQuery query){
		if(processInstanceMonitors.isEmpty()){
			return 0;
		}
		float sum = 0;
		for(ProcessInstanceMonitor processInstanceMonitor : processInstanceMonitors){
			sum += processInstanceMonitor.getRuntimeForQuery(query);
		}
		return sum / processInstanceMonitors.size();
	}
	
	public float getPathFrequencyForQuery(SushiPatternQuery query){
		if(processInstanceMonitors.isEmpty()){
			return 0;
		}
		float count = 0;
		for(ProcessInstanceMonitor processInstanceMonitor : processInstanceMonitors){
			if(processInstanceMonitor.getStatusForQuery(query).equals(QueryStatus.Finished)){
				count++;
			}
		}
		return count / processInstanceMonitors.size();
	}

	public ProcessInstanceMonitor getProcessInstanceMonitor(SushiProcessInstance processInstance) {
		for(ProcessInstanceMonitor processInstanceMonitor : processInstanceMonitors){
			if(processInstanceMonitor.getProcessInstance().equals(processInstance)){
				return processInstanceMonitor;
			}
		}
		return null;
	}
	
}
