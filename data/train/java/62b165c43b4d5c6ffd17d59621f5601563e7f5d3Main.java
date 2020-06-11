package laba1_example;

public class Main {
	
	public static void main(String[] args) throws InterruptedException {
		double[][] A = new double[10][10];
		double[] B = new double[10];
		
		ProcessManager manager = new ProcessManager();
		
		manager.addNewProcess(new Process(A, B));
		manager.addNewProcess(new Process(A, B));
		manager.addNewProcess(new Process(A, B));
		Process p1 =new Process(A, B);
		Process p2 = new Process(A, B);
		manager.addNewProcess(p2);
		manager.addNewProcess(p1);
		manager.addNewProcess(new Process(A, B));
		
		manager.run();
	}

}
