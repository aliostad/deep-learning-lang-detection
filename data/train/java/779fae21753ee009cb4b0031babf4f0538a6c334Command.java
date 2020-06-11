/**
 * @author Jeff Standen <jeff@webgroupmedia.com>
 */

package com.portsensor.command;

import java.io.IOException;
import java.io.InputStream;

public class Command {
	private Process process = null;
	
	public Command(Process process) {
		this.setProcess(process);
	}

	public String getOutput() {
		StringBuffer output = new StringBuffer();
		
		try {
			InputStream is = this.getProcess().getInputStream();
			
			while(is.available() > 0) {
				output.append((char)is.read());
			}
		} catch(IOException ioe) {
			return null;
		}
		
		return output.toString();
	}
	
	public void setInput(String input) {
		// [TODO] Implement
	}
	
	public void stop() {
		this.getProcess().destroy();
	}
	
	private Process getProcess() {
		return process;
	}

	private void setProcess(Process process) {
		this.process = process;
	}
};
