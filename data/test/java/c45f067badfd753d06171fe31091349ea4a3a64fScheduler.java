package ie.dit.scheduler.producerConsumer;

import ie.dit.scheduler.priorityQueue.Process;

public class Scheduler implements Runnable
{

	private ReadyQueue readyQueue;
	
	public Scheduler(ReadyQueue readyQueue)
	{
		this.readyQueue = readyQueue;
	}

	public ReadyQueue getReadyQueue() 
	{
		return this.readyQueue;
	}
	
	public Process dequeueReadyQueue()
	{
		return readyQueue.dequeueReadyQueue();
	}
	
	public void simulateCPUBurst(Process process)
	{
		int time = process.getProcessTime();
		
		time = time - 1;
		process.setProcessTime(time);
		process.setTimeStamp();
		process.setState(Process.WAITING);
			
		if(time<=0)
		{
			process.setState(Process.TERMINATE);
			System.out.println(process.getName() + " "+ process.getStringState());
			sleep(2500);
		}
	}
	
			
	private void sleep(int i) 
	{
		try {
			Thread.sleep(i);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
	}

	@Override
	public void run() 
	{		
		while(ReadyQueue.isReady)
		{
			Process process = readyQueue.dequeueReadyQueue();
		
			if(process!=null)
			{
				process.setState(Process.RUNNING);
				simulateCPUBurst(process);
				
			
				if(!process.getState()==Process.TERMINATE)
				{
					readyQueue.consumerEnqueueReadyQueue(process);
				}
			}
		}
				
	}

}
