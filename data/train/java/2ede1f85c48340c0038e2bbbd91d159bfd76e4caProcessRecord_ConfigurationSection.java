package nam.model.process;

import java.io.Serializable;

import javax.enterprise.context.SessionScoped;
import javax.inject.Named;

import org.aries.ui.AbstractWizardPage;

import nam.model.Process;
import nam.model.util.ProcessUtil;


@SessionScoped
@Named("processConfigurationSection")
public class ProcessRecord_ConfigurationSection extends AbstractWizardPage<Process> implements Serializable {
	
	private Process process;
	
	
	public ProcessRecord_ConfigurationSection() {
		setName("Configuration");
		setUrl("configuration");
	}
	
	
	public Process getProcess() {
		return process;
	}
	
	public void setProcess(Process process) {
		this.process = process;
	}
	
	@Override
	public void initialize(Process process) {
		setEnabled(true);
		setBackEnabled(true);
		setNextEnabled(true);
		setFinishEnabled(false);
		setProcess(process);
	}
	
	@Override
	public void validate() {
		if (process == null) {
			validator.missing("Process");
		} else {
		}
	}
	
}
