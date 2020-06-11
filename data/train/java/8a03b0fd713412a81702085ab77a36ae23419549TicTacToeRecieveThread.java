package base.thread;

import java.io.IOException;
import java.net.Socket;

import base.handler.EndCommandHandler;
import base.handler.ErrorCommandHandler;
import base.handler.MoveCommandHandler;
import base.handler.StartCommandHandler;
import base.serverinterface.TicTacToeRecieveInterface;

public class TicTacToeRecieveThread extends Thread {
	private Socket socket;
	private MoveCommandHandler moveHandler;
	private ErrorCommandHandler errorHandler;
	private EndCommandHandler endHandler;
	private StartCommandHandler startHandler;

	public TicTacToeRecieveThread(Socket socket,
			MoveCommandHandler moveHandler, ErrorCommandHandler errorHandler,
			EndCommandHandler endHandler, StartCommandHandler startHandler) {

		this.socket = socket;
		this.moveHandler = moveHandler;
		this.errorHandler = errorHandler;
		this.endHandler = endHandler;
		this.startHandler = startHandler;
	}

	public void run() {
		try {
			TicTacToeRecieveInterface recieveInterface = new TicTacToeRecieveInterface(
					this.socket);

			// Register for callbacks
			recieveInterface.registerMoveCommandHandler(this.moveHandler);
			recieveInterface.registerErrorCommandHandler(this.errorHandler);
			recieveInterface.registerEndCommandHandler(this.endHandler);
			recieveInterface.registerStartCommandHandler(this.startHandler);

			while (true) {
				// See if we are ready for input
				if (recieveInterface.isReady()) {
					recieveInterface.acceptInput();
				}
				// If not then just yield and wait for another turn
				else {
					Thread.yield();
				}
			}
		} catch (IOException e) {
			throw new RuntimeException("Should never happen");
		}
	}
}
