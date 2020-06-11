import java.util.ArrayList;

public class PWOP_Driver
{
    public static void main( String[] args)
    {
    	Process p1 = new Process(1,0,19,3);
    	Process p2 = new Process(2,2,10,2);
    	Process p3 = new Process(3,4,7,1);
    	//Process p4 = new Process(4,1,1,5);
    	//Process p5 = new Process(5,4,100,1);
    	
    	ArrayList<Process> list= new ArrayList<Process>();
    	list.add(p1);
    	list.add(p2);
    	list.add(p3);
    	//list.add(p4);
    	//list.add(p5);
    	//list.add(p6);
    	
    	PWOP_Policarpio.execute(list);
    	
    	
    
    }
}