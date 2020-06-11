package com.trontria.app.handler;

public class HandlerThread extends Thread {
	public HandlerThread(Handler handler) {
		super(new Looper(handler));
	}
	
	private static class Looper implements Runnable {
		private Handler handler;
		
		public Looper(Handler handler) {
			this.handler = handler;
		}
		
		@Override
		public void run() {
			while (true) {
				HandlerMessage msg = handler.nextMessage();
				if (msg == null) {
					// No message found
					handler.noMessage();
					continue;
				}
				
				boolean end = false;
				switch (msg.what()) {
				case Handler.MESSAGE_CODE_END_LOOP:
					// Tell the loop to end
					end = true;
					break;
				default:
					handler.handleMessage(msg);
					break;
				}
				
				// End the looper
				if (end) break;
			}
		}
	}
}
