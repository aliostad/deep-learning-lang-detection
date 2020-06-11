package com.ffmpegtest.helpers;

import java.io.IOException;

public class ProcessRunnableHelper implements Runnable
{
	private ProcessBuilder process;
	
	public ProcessRunnableHelper(ProcessBuilder process)
	{
		this.process = process;
	}
	
	@Override
	public void run()
	{
		Process proc = null;
		
		try {
			proc = process.start();
			proc.waitFor();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
