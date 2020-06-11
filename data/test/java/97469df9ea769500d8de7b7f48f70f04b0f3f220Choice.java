package eu.compassresearch.core.analysis.modelchecker.graphBuilder.process;



public abstract class Choice implements Process {
	protected Process firstProcess;
	protected Process secondProcess;
	public Choice(Process firstProcess, Process secondProcess) {
		super();
		this.firstProcess = firstProcess;
		this.secondProcess = secondProcess;
	}
	public Process getFirstProcess() {
		return firstProcess;
	}
	public void setFirstProcess(Process firstProcess) {
		this.firstProcess = firstProcess;
	}
	public Process getSecondProcess() {
		return secondProcess;
	}
	public void setSecondProcess(Process secondProcess) {
		this.secondProcess = secondProcess;
	}

	@Override
	public boolean equals(Object obj) {
		boolean result = false;
		if(obj instanceof Choice){
			Choice other = (Choice) obj;
			result = this.getFirstProcess().equals(other.getFirstProcess()) 
					 && this.getSecondProcess().equals(other.getSecondProcess());
		}
		return result;
	}	
	
}
