package eu.compassresearch.core.analysis.modelchecker.graphBuilder.process;


public class Let implements Process {
	
	private String name;
	private Process process;
	
	public Let(String name, Process process) {
		super();
		this.name = name;
		this.process = process;
	}

	@Override
	public String toString() {
		return "let " + name + " @ " + process.toString();
	}
	
	@Override
	public boolean equals(Object obj) {
		boolean result = false;
		if(obj instanceof Let){
			Let other = (Let) obj;
			result = name.equals(other.name) && this.process.equals(((Let) obj).getProcess());
		}
		return result;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Process getProcess() {
		return process;
	}

	public void setProcess(Process process) {
		this.process = process;
	}
	@Override
	public boolean isDeadlock(){
		return false;
	}

}
