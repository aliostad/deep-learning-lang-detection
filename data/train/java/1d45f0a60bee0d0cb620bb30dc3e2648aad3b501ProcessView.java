package br.com.teste.jsdm.view;

import java.util.List;

import javax.faces.bean.ManagedBean;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import br.com.teste.jsdm.model.Process;
import br.com.teste.jsdm.service.ProcessService;

// TODO: Auto-generated Javadoc
/**
 * DOCUMENT ME!.
 *
 * @author Welson
 */
@Controller
@Scope("request")
@ManagedBean(name = "processView")
public class ProcessView extends CrudView {

	/** A constante serialVersionUID. */
	private static final long serialVersionUID = 3004186622742064923L;
	
	/** process service. */
	@Autowired
	private ProcessService processService;
	
	/** process. */
	private Process process;
	
	/** list process. */
	private List<Process> listProcess;
	
	/**
	 * Search process.
	 */
	public void searchProcess() {
		setListProcess(processService.findByFilter(new Process()));
	}
	
	/* (non-Javadoc)
	 * @see br.com.teste.jsdm.view.CrudView#newItem()
	 */
	@Override
	protected void newItem() {
		erase();
	}
	
	/* (non-Javadoc)
	 * @see br.com.teste.jsdm.view.CrudView#editItem()
	 */
	@Override
	protected void editItem() {
		System.out.println("edit");
	}
	
	/**
	 * Save process.
	 */
	public void saveProcess() {
		processService.save(getProcess());
		addInfoMessage("Cadastro com sucesso");
		
		setProcess(null);
		backToSearchOperation();
	}
	
	/**
	 * Erase.
	 */
	public void erase() {
		setProcess(new Process());
	}
	
	//GET e SET
	/**
	 * Obtém process.
	 *
	 * @return process
	 */
	public Process getProcess() {
		return process;
	}
	
	/**
	 * Define process.
	 *
	 * @param process novo process
	 */
	public void setProcess(Process process) {
		this.process = process;
	}
	
	/**
	 * Obtém list process.
	 *
	 * @return list process
	 */
	public List<Process> getListProcess() {
		return listProcess;
	}
	
	/**
	 * Define list process.
	 *
	 * @param listProcess novo list process
	 */
	public void setListProcess(List<Process> listProcess) {
		this.listProcess = listProcess;
	}

}
