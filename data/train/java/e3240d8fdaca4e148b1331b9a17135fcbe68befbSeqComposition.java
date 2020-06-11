package eu.compassresearch.core.analysis.modelchecker.graphBuilder.process;

public class SeqComposition implements Process {
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

	private Process firstProcess;
	private Process secondProcess;
	
	
	public SeqComposition(Process firstProcess, Process secondProcess) {
		this.firstProcess = firstProcess;
		this.secondProcess = secondProcess;
	}
	
	@Override
	public String toString() {
		return "(" + firstProcess.toString() + ")" + ";" + "(" + secondProcess.toString() + ")";
	}


	@Override
	public boolean equals(Object obj) {
		boolean result = false;
		if(obj instanceof SeqComposition){
			SeqComposition other = (SeqComposition) obj;
			result = this.getFirstProcess().equals(other.getFirstProcess()) && this.getSecondProcess().equals(other.getSecondProcess());
		}
		return result;
	}	
	@Override
	public boolean isDeadlock(){
		return false;
	}

}
