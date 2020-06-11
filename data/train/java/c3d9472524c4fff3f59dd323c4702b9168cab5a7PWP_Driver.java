import java.util.ArrayList;

public class PWP_Driver
{
    public static void main( String[] args)
    {
    	Process_Policarpio p1 = new Process_Policarpio(1,0,19,3);
    	Process_Policarpio p2 = new Process_Policarpio(2,2,10,2);
    	Process_Policarpio p3 = new Process_Policarpio(3,4,7,1);
    	//Process_Policarpio p4 = new Process_Policarpio(4,0,30,30);
    	//Process_Policarpio p5 = new Process_Policarpio(5,20,7,7);
    	
    	ArrayList<Process_Policarpio> list= new ArrayList<Process_Policarpio>();
    	list.add(p1);
    	list.add(p2);
    	list.add(p3);
    	//list.add(p4);
    	//list.add(p5);
    	
    	PWP_Policarpio.execute(list);
    	
    	
    
    }
}