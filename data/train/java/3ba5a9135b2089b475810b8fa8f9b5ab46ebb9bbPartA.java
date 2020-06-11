package cpu;

/*
 * PartA: this class will use the heap sort to sort and print an 
 * array of processes based on priority and time stamp
 * */
public class PartA {

	/*
	 * this class HAS A process array to store processes, a heap sort to
	 * perform the sorting
	 * */
	Process[] processArray;
	ProcessHeapSort heapSort;
	
	/*
	 * constructor
	 * */
	public PartA(Process[] processArray){
		this.processArray = processArray;
		this.heapSort = new ProcessHeapSort();
	}
	
	public static void main(String[] args) {
			
		
		//create process array 
		Process[] processArray = new Process[9];
		
		/*
		 * create processes to sort as specified in the  assignment
		 * */
		Process p1 = new Process(PriorityClass.CRITICAL, (long) 100);
		Process p2 = new Process(PriorityClass.NORMAL, (long) 50);
		Process p3 = new Process(PriorityClass.BACKGROUND, (long) 1000);
		Process p4 = new Process(PriorityClass.BACKGROUND, (long) 900);
		Process p5 = new Process(PriorityClass.NORMAL, (long) 100);
		Process p6 = new Process(PriorityClass.CRITICAL, (long) 1000);
		Process p7 = new Process(PriorityClass.CRITICAL, (long) 1);
		Process p8 = new Process(PriorityClass.NORMAL, (long) 1000);
		Process p9 = new Process(PriorityClass.CRITICAL, (long) 1);
		
		//add processes to process array to sort
		processArray[0] = p1;
		processArray[1] = p2;
		processArray[2] = p3;
		processArray[3] = p4;
		processArray[4] = p5;
		processArray[5] = p6;
		processArray[6] = p7;
		processArray[7] = p8;
		processArray[8] = p9;
		
		PartA main = new PartA(processArray);
		/*
		 * add process array to the heap sort
		 * */
		main.heapSort.heapSort(processArray);
		
		System.out.println("sorted process array:");
		System.out.println("");
		
		/*
		 * sort array and print to screen
		 * */
		for(Process p: main.heapSort.getSortedMaxHeap()){
			System.out.println(p);
		}
		
	}

}
