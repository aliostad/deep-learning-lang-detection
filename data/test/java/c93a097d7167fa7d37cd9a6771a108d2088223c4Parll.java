package eu.compassresearch.core.analysis.modelchecker.graphBuilder.process;


public class Parll implements ParallelProcess {
	
	
	public Process getStartProcess() {
		return startProcess;
	}


	public void setStartProcess(Process startProcess) {
		this.startProcess = startProcess;
	}


	public String getStr1() {
		return str1;
	}


	public void setStr1(String str1) {
		this.str1 = str1;
	}


	public String getStr2() {
		return str2;
	}


	public void setStr2(String str2) {
		this.str2 = str2;
	}


	public String getStr3() {
		return str3;
	}


	public void setStr3(String str3) {
		this.str3 = str3;
	}


	public Process getEndProcess() {
		return endProcess;
	}


	public void setEndProcess(Process endProcess) {
		this.endProcess = endProcess;
	}


	private Process startProcess;
	private String str1;
	private String str2;
	private String str3;
	private Process endProcess;
	
	
	public Parll(Process startProcess, String str3, String str2, String str1, Process endProcess) {
		this.startProcess = startProcess;
		this.str1 = str1;
		this.str2 = str2;
		this.str3 = str3;
		this.endProcess = endProcess;
		
	}

	@Override
	public boolean equals(Object obj) {
		boolean result = false;
		if(obj instanceof Parll){
			Parll other = (Parll) obj;
			result = this.getStartProcess().equals(other.getStartProcess())
					&& this.getEndProcess().equals(other.getEndProcess());
					//this.getStr1().equals(other.getStr1())
					//&& this.getStr2().equals(other.getStr2())
					//&& this.getStr3().equals(other.getStr3()); 
		}
		return result;
	}
	
	@Override
	public boolean isDeadlock(){
		return false;
	}

	

}
