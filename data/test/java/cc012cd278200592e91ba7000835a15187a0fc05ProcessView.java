package cl.alma.scrw.ui.processes;

import java.util.List;

import org.activiti.engine.repository.ProcessDefinition;

import com.github.peholmst.mvp4vaadin.navigation.ControllableView;

/**
 * This interface shows the necessary methods that ProcessViewImpl will implement, and ProcessPresenter will call.  
 * modified by Mauricio Pilleux
 *
 */
public interface ProcessView extends ControllableView {

	String VIEW_ID = "process";

	/**
	 * Sets the list of process definitions.
	 * This list of processes will be shown by the view.
	 * The ProcessPresented is in charge of stting this list.
	 * @param definitions = List of process definitions to be set in the view.
	 */
	void setProcessDefinitions( List<ProcessDefinition> definitions );
	
	/**
	 * Sets the list of suspended process definitions.
	 * This list will be set in one of the tabs in the view.
	 * The ProcessPresented is in charge of stting this list.
	 * @param definitions
	 */
	void setSuspendedProcessDefinitions( List<ProcessDefinition> definitions );

	/**
	 * Display a message to indicate process was started successfully. 
	 * @param process = process that started successfully.
	 */
	void showProcessStartSuccess( ProcessDefinition process );

	/**
	 * Display a message to indicate process encountered an error when trying to deploy. 
	 * @param process = process that started unsuccessfully.
	 */
	void showProcessStartFailure( ProcessDefinition process );
	
	/**
	 * Display a message to indicate that the suspension of a process was successful.
	 * @param process = suspended process.
	 */
	public void showProcessSuspendSuccess( ProcessDefinition process );
	
	/**
	 * Display a message to indicate that the suspension of a process was unsuccessful.
	 * @param process = non suspended process.
	 */
	public void showProcessSuspendFailure( ProcessDefinition process );
	
	/**
	 * Display a message to indicate that the activation of a process was successful.
	 * @param process = activated process.
	 */
	public void showProcessActivatedSuccess( ProcessDefinition process );
	
	/**
	 * Display a message to indicate that the activation of a process was unsuccessful.
	 * @param process = non activated process.
	 */
	public void showProcessActivatedFailure( ProcessDefinition process );
}
