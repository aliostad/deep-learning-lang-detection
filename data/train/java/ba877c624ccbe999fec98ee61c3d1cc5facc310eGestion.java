import java.util.*;

public class Gestion {
	Scanner scan=new Scanner(System.in);
	
	public Gestion(){
		
		Random_Access_Memory ram=setRam();
		Process processus=Add_process();
	
		while(launch_process(processus,ram)==true)
		{
			ram.updateRam(processus,1);
			processus=Add_process();
		}
	}
	
	public static boolean stop_process(Process processus,Random_Access_Memory ram){
		
		
		return true;
	}
	public static boolean launch_process(Process processus,Random_Access_Memory ram){
		float size=processus.getSize_process()+ram.getSize_Process_exec();
		
		if(size<ram.getSize_ram()){
			return true;
		}else{
			return false;
		}	
	}
	
	public Process Add_process(){
		
		Process process=new Process();
		process.setProcess();
		
		return process;
	}
	
	public static Random_Access_Memory setRam(){
		Random_Access_Memory ram=new Random_Access_Memory();
		
		return ram;
		
	}
}
