public class IOExecution extends Thread{
	Process process;
        LinkedList<Process> waitQueue;
	public void setProcess(Process process){
		this.process = process;
	}
        public void setWaitQueue(LinkedList<Process> waitQueue){
            this.waitQueue=waitQueue;
        }
	synchronized public void run(){
		process.ioQueueWait[(process.currentBurst-1)/2] = System.currentTimeMillis() - process.ioQueueWait[(process.currentBurst-1)/2];
		try{
                    Thread.sleep(process.bursts[process.currentBurst]);
                    waitQueue.remove(process);
                }catch(InterruptedException e){
				System.out.println(e);
		} 
                
	}

}
