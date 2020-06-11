package eu.compassresearch.core.analysis.modelchecker.ast.process;




public class MCASequentialCompositionProcess implements MCPProcess {

	protected MCPProcess leftProcess;
	protected MCPProcess rightProcess;
	
	public MCASequentialCompositionProcess(
			MCPProcess leftProcess, 
			MCPProcess rightProcess) {
		super();
		this.leftProcess = leftProcess;
		this.rightProcess = rightProcess;
	}



	@Override
	public String toFormula(String option) {
		StringBuffer result = new StringBuffer();
		
		// it writes the sequential composition constructor
		result.append("seqC(");
		result.append(this.leftProcess.toFormula(option));
		result.append(",");
		result.append(this.rightProcess.toFormula(option));
		result.append(")");

		return result.toString();
	}



	public MCPProcess getLeftProcess() {
		return leftProcess;
	}



	public void setLeftProcess(MCPProcess leftProcess) {
		this.leftProcess = leftProcess;
	}



	public MCPProcess getRightProcess() {
		return rightProcess;
	}



	public void setRightProcess(MCPProcess rightProcess) {
		this.rightProcess = rightProcess;
	}


	

	
}
