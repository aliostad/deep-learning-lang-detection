package codeOrchestra.colt.core.execution;

/**
 * @author Alexander Eliseyev
 */
public class ProcessHandlerWrapper {
	
	private boolean mustWaitForExecutionEnd;
	private ProcessHandler processHandler;
	
	public ProcessHandlerWrapper(ProcessHandler processHandler, boolean mustWaitForExecutionEnd) {
		this.processHandler = processHandler;
    this.mustWaitForExecutionEnd = mustWaitForExecutionEnd;		
	}

  public boolean mustWaitForExecutionEnd() {
    return mustWaitForExecutionEnd;
  }

  public ProcessHandler getProcessHandler() {
    return processHandler;
  }

}
