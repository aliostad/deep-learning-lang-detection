package org.springframework.integration.ext.samples.twitter.processmanager;

import org.springframework.integration.core.Message;
import org.springframework.integration.message.MessageHandler;

/**
 * @author Alex Peters
 * 
 */
public interface ProcessController<T> {

	boolean addMessageHandler(MessageHandler handler);

	boolean removeMessageHandler(MessageHandler handler);

	boolean hasNextHandler(T pid);

	MessageHandler nextHandler(T pid);

	T createOrUpdate(Message<?> message);

	Message<?> nextMessage(T pid);

	void cleanup(T pid);

}
