package sushi.application.pages.monitoring.bpmn.analysis.model;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.wicket.extensions.markup.html.repeater.data.sort.ISortState;
import org.apache.wicket.extensions.markup.html.repeater.data.table.ISortableDataProvider;
import org.apache.wicket.extensions.markup.html.repeater.data.table.filter.IFilterStateLocator;
import org.apache.wicket.extensions.markup.html.repeater.util.SingleSortState;
import org.apache.wicket.model.IModel;
import org.apache.wicket.model.Model;

import sushi.application.components.table.model.AbstractDataProvider;
import sushi.monitoring.bpmn.BPMNQueryMonitor;
import sushi.monitoring.bpmn.ProcessMonitor;

/**
 * This class is the provider for {@link ProcessMonitor}s.
 * A filter can be specified to return only some ProcessMonitors.
 * @author micha
 */
public class ProcessMonitoringProvider extends AbstractDataProvider implements ISortableDataProvider<ProcessMonitor, String>, IFilterStateLocator {
	
	private static final long serialVersionUID = 1L;
	private static List<ProcessMonitor> processMonitors;
	private static List<ProcessMonitor> selectedProcessMonitors;
	private ISortState sortState = new SingleSortState();
	private ProcessMonitoringFilter processMonitorFilter = new ProcessMonitoringFilter();
	
	/**
	 * Constructor for providing {@link ProcessMonitor}s.
	 */
	public ProcessMonitoringProvider() {
		processMonitors = BPMNQueryMonitor.getInstance().getProcessMonitors();
		selectedProcessMonitors = new ArrayList<ProcessMonitor>();
	}
	
	@Override
	public void detach() {
//		processMonitors = null;
	}
	
	@Override
	public Iterator<? extends ProcessMonitor> iterator(long first, long count) {
		return processMonitors.subList((int)first, (int)Math.min(first + count, processMonitors.size())).iterator();
	}

	private List<ProcessMonitor> filterProcessMonitors(List<ProcessMonitor> processMonitorsToFilter, ProcessMonitoringFilter processMonitorFilter) {
		List<ProcessMonitor> returnedProcessMonitors = new ArrayList<ProcessMonitor>();
		for(ProcessMonitor processMonitor: processMonitorsToFilter){
			if(processMonitorFilter.match(processMonitor)){
				returnedProcessMonitors.add(processMonitor);
			}
		}
		return returnedProcessMonitors;
	}

	@Override
	public IModel<ProcessMonitor> model(ProcessMonitor processMonitor) {
		return Model.of(processMonitor);
	}

	@Override
	public long size() {
		return processMonitors.size();
	}

	public List<ProcessMonitor> getProcessMonitors() {
		return processMonitors;
	}
	
	public List<ProcessMonitor> getSelectedProcessMonitors(){
		return selectedProcessMonitors;
	}

	public static void setProcessMonitors(List<ProcessMonitor> processMonitorList) {
		processMonitors = processMonitorList;
	}

	@Override
	public ISortState<String> getSortState() {
		return sortState;
	}

	@Override
	public Object getFilterState() {
		return processMonitorFilter;
	}

	@Override
	public void setFilterState(Object state) {
		this.processMonitorFilter = (ProcessMonitoringFilter) state;
	}

	public ProcessMonitoringFilter getProcessMonitorFilter() {
		return processMonitorFilter;
	}

	public void setProcessMonitorFilter(ProcessMonitoringFilter processMonitorFilter) {
		this.processMonitorFilter = processMonitorFilter;
		processMonitors = filterProcessMonitors(processMonitors, processMonitorFilter);
	}
	
	@Override
	public void selectEntry(int entryId) {
		for (Iterator iter = processMonitors.iterator(); iter.hasNext();) {
			ProcessMonitor processMonitor = (ProcessMonitor) iter.next();
			if(processMonitor.getID() == entryId) {
				selectedProcessMonitors.add(processMonitor);
				return;
			}
		}
	}
	
	@Override
	public void deselectEntry(int entryId) {
		for (Iterator<ProcessMonitor> iter = processMonitors.iterator(); iter.hasNext();) {
			ProcessMonitor processMonitor = (ProcessMonitor) iter.next();
			if(processMonitor.getID() == entryId) {
				selectedProcessMonitors.remove(processMonitor);
				return;
			}
		}
	}
	
	@Override
	public boolean isEntrySelected(int entryId) {
		for (ProcessMonitor processMonitor : selectedProcessMonitors) {
			if(processMonitor.getID() == entryId) {
				return true;
			}
		}
		return false;
	}

	public void deleteSelectedEntries() {
		for(ProcessMonitor processMonitor : selectedProcessMonitors){
			processMonitors.remove(processMonitor);
		}
	}

	public void selectAllEntries() {
		for(ProcessMonitor processMonitor : processMonitors){
			selectedProcessMonitors.add(processMonitor);
		}
	}
	
	@Override
	public Object getEntry(int entryId) {
		for(ProcessMonitor processMonitor : processMonitors){
			if(processMonitor.getID() == entryId){
				return processMonitor;
			}
		}
		return null;
	}

}
