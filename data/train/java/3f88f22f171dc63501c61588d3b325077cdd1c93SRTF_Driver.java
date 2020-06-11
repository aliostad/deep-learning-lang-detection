import java.util.ArrayList;

public class SRTF_Driver
{
    public static void main( String[] args)
    {
    	Process_Policarpio p1 = new Process_Policarpio(1,24,3);
    	Process_Policarpio p2 = new Process_Policarpio(2,5,20);
    	Process_Policarpio p3 = new Process_Policarpio(3,15,5);
    	Process_Policarpio p4 = new Process_Policarpio(4,0,30);
    	Process_Policarpio p5 = new Process_Policarpio(5,20,7);
    	
    	ArrayList<Process_Policarpio> list= new ArrayList<Process_Policarpio>();
    	list.add(p1);
    	list.add(p2);
    	list.add(p3);
    	list.add(p4);
    	list.add(p5);
    	
    	SRTF_Policarpio.execute(list);
    	
    	
    
    }
}