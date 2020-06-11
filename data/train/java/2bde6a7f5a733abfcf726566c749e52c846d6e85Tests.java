package test;

import java.io.IOException;
import java.util.ArrayList;

import util.Util;
import entity.Process;
import entity.Scheduler;
import entity.SchedulerFIFO;
import cores.Core;
import cores.CoreAccessMemory;
import cores.CoreCacheMiss;
import cores.CoreCalculations;

public class Tests {

	// test of load process from file
	public void testLoad(){
		
		try{
			Util.init();
		}
		catch(IOException e){
			
			e.printStackTrace();
		}
		
		Core core = new Core(1);
		Process pt  =  Util.queueProcess.get(0);
		Process pt1  =  Util.queueProcess.get(1);
		Process pt2  =  Util.queueProcess.get(2);
		Process pt3  =  Util.queueProcess.get(3);
		Process pt4 = Util.queueProcess.get(4);
		
		core.putProcess(pt);
		core.putProcess(pt1);
		core.putProcess(pt2);
		core.putProcess(pt3);
		core.putProcess(pt4);
		
		for (Process process : Util.queueProcess){
			
			System.out.println(process.toString());			
		}
		
	}
	
	//test process in core
	public void testProcessInCore(){
		try{
			Util.init(); 
		}
		catch(IOException e){
			e.printStackTrace();
		}
		
		Core core = new Core(1);
		Process pt  =  Util.queueProcess.get(0);
		Process pt1  =  Util.queueProcess.get(1);
		Process pt2  =  Util.queueProcess.get(2);
		Process pt3  =  Util.queueProcess.get(3);
		Process pt4 = Util.queueProcess.get(4);
		
		core.putProcess(pt);
		core.putProcess(pt1);
		core.putProcess(pt2);
		core.putProcess(pt3);
		core.putProcess(pt4);
		
		for (Process process : Util.queueProcess) {

			System.out.println(process.toString());
		}
		
	}

	//Test process in core CacheMiss
	public void testProcessInCoreCacheMiss(){
		try{
			Util.init(); 
		}
		catch(IOException e){
			e.printStackTrace();
		}
		
		CoreCacheMiss core = new CoreCacheMiss(1);
		Process pt  =  Util.queueProcess.get(0);
		Process pt1  =  Util.queueProcess.get(1);
		Process pt2  =  Util.queueProcess.get(2);
		Process pt3  =  Util.queueProcess.get(3);
		Process pt4 = Util.queueProcess.get(4);
		
		core.putProcess(pt);
		core.putProcess(pt1);
		core.putProcess(pt2);
		core.putProcess(pt3);
		core.putProcess(pt4);
		
		for (Process process : Util.queueProcess) {

			System.out.println(process.toString());
		}
		
	}
	
	//Test process in core CacheAccessMemory
		public void testProcessInCoreAccessMemory(){
			try{
				Util.init(); 
			}
			catch(IOException e){
				e.printStackTrace();
			}
			
			CoreAccessMemory core = new CoreAccessMemory(1);
			Process pt  =  Util.queueProcess.get(0);
			Process pt1  =  Util.queueProcess.get(1);
			Process pt2  =  Util.queueProcess.get(2);
			Process pt3  =  Util.queueProcess.get(3);
			Process pt4 = Util.queueProcess.get(4);
			
			core.putProcess(pt);
			core.putProcess(pt1);
			core.putProcess(pt2);
			core.putProcess(pt3);
			core.putProcess(pt4);
			
			for (Process process : Util.queueProcess) {

				System.out.println(process.toString());
			}
			
		}

	// Test process in core CacheCalculations
	public void testProcessInCoreCalculations() {
		try {
			Util.init();
		} catch (IOException e) {
			e.printStackTrace();
		}

		CoreCalculations core = new CoreCalculations(1);
		Process pt = Util.queueProcess.get(0);
		Process pt1 = Util.queueProcess.get(1);
		Process pt2 = Util.queueProcess.get(2);
		Process pt3 = Util.queueProcess.get(3);
		Process pt4 = Util.queueProcess.get(4);

		core.putProcess(pt);
		core.putProcess(pt1);
		core.putProcess(pt2);
		core.putProcess(pt3);
		core.putProcess(pt4);

		for (Process process : Util.queueProcess) {

			System.out.println(process.toString());
		}

	}
	
	//Test scheduler, scheduling the cores
	
	public void testScheduler(){
				
		Scheduler scheduler = new Scheduler();
		
		try {
			Util.init();
		} catch (IOException e) {
			e.printStackTrace();
		}
	
		
		//Motor do simulador
		while(Util.numProcess < Util.numProcessTotal){
			
			//Verifica se chegou algum processo para ser executado
			for (Process process : Util.queueProcess)			
				if(process.getTimeArriving() == Util.timeClock)
					Util.addProcessInQueueReady(process);
		
			//Tenta inserir o processo no core mais adequado
			for(Process process : Util.queueReady){
				if(!scheduler.chooseCore(process))
					break;
			}
			
			
			Util.executeCores();
			Util.plusTimerClock();
		}
		
		for (Process process : Util.queueFinished) {
			System.out.println(process.toString());
		}
		
	}
	

/*	
	public void testeSchedulerFIFO() {
		
		SchedulerFIFO schedulerFIFO = new SchedulerFIFO();
		
		try {
			Util.init();
		} catch (IOException e) {
			e.printStackTrace();
		}

		Process pt = Util.queueProcess.get(0);
		Process pt1 = Util.queueProcess.get(1);
		Process pt2 = Util.queueProcess.get(2);
		Process pt3 = Util.queueProcess.get(3);
		Process pt4 = Util.queueProcess.get(4);
		
		while(Util.timeClock <= 50){
			
			schedulerFIFO.alocaProcess(pt);
			schedulerFIFO.alocaProcess(pt1);
			schedulerFIFO.alocaProcess(pt2);
			schedulerFIFO.alocaProcess(pt3);
			schedulerFIFO.alocaProcess(pt4);
			
			//Util.timeClock++;
			
		}
		
		for (Process process : Util.queueProcess) {

			System.out.println(process.toString());
		}
		
	}*/
	public static void main(String[] args) {
		
		Tests test = new Tests();
		
		/*System.out.println("Test Load from file");
		test.testLoad();
		
		System.out.println("\n Test process in core");
		test.testProcessInCore();
		
		System.out.println("\n Teste process in Core Cache Miss");
		test.testProcessInCoreCacheMiss();
		
		System.out.println("\n Tests process in core Access Mememory");
		test.testProcessInCoreAccessMemory();
		
		System.out.println("\n Tests process in core Calculations");
		test.testProcessInCoreCalculations();
		
		System.out.println("\n Tests Scheduler");
		test.testScheduler();
		
		System.out.println("\n Tests SchedulerFIFO");
		test.testeSchedulerFIFO();*/
		
		System.out.println("Test Simulator\n");
		test.testScheduler();

	}

}
