package com.gceylan.test;

import java.util.Map;

import com.gceylan.model.Process;
import com.gceylan.service.ProcessService;

public class Run {

	public static void main(String[] args) {
		
		/*
		ProcessService ps = new ProcessService("localhost");
		Map<String, Process> allProcess = ps.getAllProcess();
		
		Map<String, Process> svchosts = ps.getAllProcessWithName("svchost.exe");
		
		for (Process process : svchosts.values()) {
			System.out.printf("[%5s] [%10s] %-26s:\t%s\n", process.getProcessId(), process.getWorkingSetSize(), process.getName(), process.getExecutablePath());
		}

		for (Process process : allProcess.values()) {
			System.out.printf("[%5s] [%10s] %-26s:\t%s\n", process.getProcessId(), process.getWorkingSetSize(), process.getName(), process.getExecutablePath());
		}
		
		*/
		
		Thread t = new Thread(new Runnable() {
			
			ProcessService ps = new ProcessService("localhost");
			Process p;
			
			@Override
			public void run() {
				
				
				while (true) {
					int memory = 0;
					
					try {
						Map<String, Process> processes = ps.getAllProcessWithName("javaw.exe");
						
						for (Process process : processes.values()) {
							System.out.printf("[%5s] [%20s] -> %-26s:\t%s\n", process.getProcessId(), Integer.parseInt(process.getWorkingSetSize()) / 1024, process.getName(), process.getExecutablePath());
							memory += Integer.parseInt(process.getWorkingSetSize());
						}
						
						System.out.println(" --->> memory: " + memory / 1024.0 + " K");
						
						Thread.sleep(1000);
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}
			}
		});
		
		t.start();
		
		/*
		 * "Eğitim, ögrendiklerinizi unuttuğunuzda geriye kalan izlerdir.
		 * Iyi eğitim derin izler bırakır. Ve kritik durumlarda, öğrendiklerinizin sizde bıraktığı 
		 * izler yardımıyla yeni bilgiler üretir, yeni kararlar alabilirsiniz. 
		 * Ĕğitim bilmediğiniz durumlarla karşılaştığınızda soğukkanlılığınızı koruyabilmenize yarar."
		 * 
		 */
		
		/*
		
		Thread t = new Thread(new Runnable() {

			ProcessService ps = new ProcessService("localhost");
			Process p;

			@Override
			public void run() {

				while (true) {
					try {
						Map<String, Process> eclipse = ps.getAllProcessWithName("eclipse.exe");

						if (eclipse.size() > 1) {
							for (Process process : eclipse.values()) {
								System.out.printf("[%5s] [%10s] %-26s:\t%s\n", process.getProcessId(), Integer.parseInt(process.getWorkingSetSize()) / 1024, process.getName(), process.getExecutablePath());
							}
						}

						Thread.sleep(3000);
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}
			}
		});

		t.start();
		
		*/
	}
}
