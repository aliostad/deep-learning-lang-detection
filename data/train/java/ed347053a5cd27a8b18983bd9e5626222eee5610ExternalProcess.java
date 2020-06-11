/* ***************************************************************************
 $Header: //MyDataDepot/Projects/provenance-autotype2/haathi4j/ExternalProcess/src/com/haathi/process/ExternalProcess.java#2 $
 *****************************************************************************
 Package
 ****************************************************************************/
package com.haathi.process;
/* ***************************************************************************
 Imports
 ****************************************************************************/
import java.lang.ProcessBuilder;
import java.lang.Process;
import java.util.ArrayList;
import java.util.List;
/* ***************************************************************************
 Class
 ****************************************************************************/
public class ExternalProcess {
	protected ProcessBuilder processBuilder;
	protected ArrayList<String> command;
	
	public ExternalProcess() {
		this(new ArrayList<String>());
	}
	
	public ExternalProcess(String command) {
		this();
		this.command.add(command);
	}
	
	public ExternalProcess(ArrayList<String> command) {
		this.command = command;
		processBuilder = new ProcessBuilder(command);
	}
	
	public ProcessBuilder getProcessBuilder() {
		return processBuilder;
	}
	
	public void execute() throws Exception {
		Process process = processBuilder.start();
		
		int result = process.waitFor();
		if (result != 0) {
			throw new Exception("Process " + (command.size() > 0 ? "\"" + command.get(0) + "\"" : "") + " terminated abnormally!");
		}
	}
	
	public List<String> command() {
		return processBuilder.command();
	}
	
	public void directory(String name) {
		processBuilder.directory(new java.io.File(name));
	}
	
	public void environment(String name, String value) {
		processBuilder.environment().put(name, value);
	}
}
/* **************************************************************************/
