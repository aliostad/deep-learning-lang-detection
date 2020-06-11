import java.util.ArrayList;

public class SJF_Driver
{
    public static void main( String[] args)
    {
    	Process p1 = new Process(1,15,5);
    	Process p2 = new Process(2,5,7);
    	Process p3 = new Process(3,0,20);
    	//Process p4 = new Process(4,16,7);
    	//Process p5 = new Process(5,14,3);
    	
    	ArrayList<Process> list= new ArrayList<Process>();
    	list.add(p1);
    	list.add(p2);
    	list.add(p3);
    	//list.add(p4);
    	//list.add(p5);
    	
    	SJF_Policarpio.execute(list);
    	
    	
    
    }
}