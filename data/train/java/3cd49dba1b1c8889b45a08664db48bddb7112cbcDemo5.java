package com.sonny.demo.thread.demo_5;

public class Demo5 {

	
	
	public static void main(String[] args) {
		ManageQueue manageQueue = new ManageQueue();
		
		Producer producer = new Producer(manageQueue);
		Consumer consumer = new Consumer(manageQueue);
		
		new Thread(producer).start();
		new Thread(consumer).start();
	}

}


class Producer implements Runnable {

	private ManageQueue manageQueue;
	
	public Producer(ManageQueue manageQueue){
		this.manageQueue = manageQueue;
	}
	
	@Override
	public void run() {
		for (int i = 0; i < 100; i++) {
			
			try {
				Thread.currentThread().sleep((int) (Math.random() * 100));
				Person person =  new Person();
				
				person.setName("Person " + i);
				person.setId(i);
				manageQueue.enqueue(person);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			
		}
		
	}
	
}

class Consumer implements Runnable {

	private ManageQueue manageQueue;
	
	public Consumer(ManageQueue manageQueue) {
		this.manageQueue = manageQueue;
	}
	
	@Override
	public void run() {
		for (int i = 0; i < 100; i++) {
			
			try {
				Thread.currentThread().sleep((int) (Math.random() * 100));
				Person person = manageQueue.dequeue();
				System.out.println("Current Person: " + person.getName());
				
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			
		}
	}
	
}