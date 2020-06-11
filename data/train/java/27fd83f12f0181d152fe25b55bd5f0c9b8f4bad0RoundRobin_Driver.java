import java.util.ArrayList;

public class RoundRobin_Driver
{
    public static void main( String[] args)
    {
    	Process p1 = new Process_Policarpio(0,20,5);
    	Process p2 = new Process_Policarpio(1,0,3);
    	Process p3 = new Process_Policarpio(2,0,8);
    	Process p4 = new Process_Policarpio(3,0,6);
    	//Process_Policarpio p5 = new Process_Policarpio(4,50,6);
    	
    	ArrayList<Process_Policarpio> list= new ArrayList<Process_Policarpio>();
    	list.add((Process_Policarpio) p1);
    	list.add((Process_Policarpio) p2);
    	list.add((Process_Policarpio) p3);
    	list.add((Process_Policarpio) p4);
    	//list.add(p5);
    	
    	RR_Policarpio.execute(list,2);
    	
    	
    
    }
}