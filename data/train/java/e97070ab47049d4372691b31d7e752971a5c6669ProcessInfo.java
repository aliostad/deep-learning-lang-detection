package processManaging;

import java.util.concurrent.Future;
import processMigration.MigratableProcess;

public class ProcessInfo {
	
	private Future<?> f;
	private MigratableProcess p;
	private String processName;
	private String processArgs;
	private String filePath;
	
	public ProcessInfo(Future<?> f, MigratableProcess p, String processName, String processArgs, String filePath){
		this.f=f;
		this.p=p;
		this.processName = processName;
		this.processArgs = processArgs;
		this.filePath=filePath;
	}
	public Future<?> getFuture(){
		return f;
	}
	
	public MigratableProcess getProcess(){
		return p;
	}
	
	public String getFilePath(){
		return filePath;
	}
	public String getProcessName() {
		return processName;
	}
	
	public String getProcessArgs() {
		return processArgs;
	}
}
