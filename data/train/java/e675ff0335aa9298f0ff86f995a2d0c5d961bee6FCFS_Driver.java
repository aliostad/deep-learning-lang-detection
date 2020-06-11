import java.util.ArrayList;

public class FCFS_Driver
{
    public static void main( String[] args)
    {
    	Process p1 = new Process(1,0,5);
    	Process p2 = new Process(2,1,3);
    	Process p3 = new Process(3,2,8);
    	Process p4 = new Process(4,3,6);
    	
    	ArrayList<Process> list= new ArrayList<Process>();
    	list.add(p4);
    	list.add(p1);
    	list.add(p2);
    	list.add(p3);

    	
    	FCFS_Policarpio.execute(list);
    	
    	Process p5 = new Process(1,0,7);
    	Process p6 = new Process(2,2,4);
    	Process p7 = new Process(3,6,1);
    	Process p8 = new Process(4,50,4);
    	ArrayList<Process> list2 = new ArrayList<Process>();
    	list2.add(p5);
    	list2.add(p6);
    	list2.add(p7);
    	list2.add(p8);
    	
    	//FCFS_Policarpio.execute(list2);
    	
    
    }
}