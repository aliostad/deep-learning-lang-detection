package bully;

public class BullyAlgorithm {
	static final int NUMBER_OF_PROCESSES = 8;
	
	public static void main(String[] args) {
		System.out.println("Bully Algorithm..................");
		System.out.println("");
		Process[] processContainer = createProcesses(NUMBER_OF_PROCESSES);
		startProcesses(processContainer);
		
	}
	
	static void startProcesses(Process[] processContainer){
		for(int i=0; i<processContainer.length; ++i){
			processContainer[i].setProcessContainer(processContainer);
			processContainer[i].start();
		}
	}
	
	
	static Process[] createProcesses(final int numberOfProcessesToInitiate){
		Process[] processContainer = new Process[numberOfProcessesToInitiate];
		for(int i=0; i<numberOfProcessesToInitiate; ++i){
			MessageQueue messageQueue = new MessageQueue();
			Communicator communicator = new Communicator(i, messageQueue);
			Protocol protocol = new Protocol(i, communicator);
			MyThread myThread = new MyThread(protocol);
			Process process = new Process(i, 
										communicator, 
										protocol,
										myThread);
			protocol.setProcess(process);
			processContainer[i] = process;
		}
		return processContainer;
	}
}
