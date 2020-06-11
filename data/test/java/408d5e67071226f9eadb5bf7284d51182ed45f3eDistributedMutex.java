
public class DistributedMutex {
	
	public static void main (String[] args){	
	
		CommMatrix cm = new CommMatrix(8);
		
		cm.setM(0, 1, new Message(Message.Token, 1));
		
		Process p0 = new Process(0, 1, cm, Protocol.Token);
		Process p1 = new Process(1, 1, cm, Protocol.Token);
		Process p2 = new Process(2, 1, cm, Protocol.Ricart);
		Process p3 = new Process(3, 1, cm, Protocol.Ricart);
		Process p4 = new Process(4, 1, cm, Protocol.Ricart);
		Process p5 = new Process(5, 1, cm, Protocol.Lamport);
		Process p6 = new Process(6, 1, cm, Protocol.Lamport);
		Process p7 = new Process(7, 1, cm, Protocol.Lamport);
		
		p0.start();
		p1.start();
		p2.start();
		p3.start();
		p4.start();
		p5.start();
		p6.start();
		p7.start();
	
	}
	
}
