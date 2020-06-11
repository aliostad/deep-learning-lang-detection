package edu.illinois.cs425.mp3;

import edu.illinois.cs425.mp3.messages.GenericMessage;

/*
 * Central class for processing messages
 */
public class MessageHandler extends Thread {
    private final Process process;
    private final GenericMessage message;
	public Process getProcess() {
		return process;
	}

	public MessageHandler(GenericMessage message, Process process) {
		this.process = process;
		this.message = message;
	}

	@Override
	public void run() {
		try {
			message.processMessage(process);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
