package message.system.service.locator;

import message.system.service.api.MessageRecipientsService;
import message.system.service.api.MessagesService;

public interface ServiceLocator {

	/**
	 * Gets the message recipients service.
	 * 
	 * @return the message recipients service
	 */
	MessageRecipientsService getMessageRecipientsService();

	/**
	 * Gets the messages service.
	 * 
	 * @return the messages service
	 */
	MessagesService getMessagesService();

	/**
	 * Sets the message recipients service.
	 * 
	 * @param messageRecipientsService
	 *            the new message recipients service
	 */
	void setMessageRecipientsService(
			MessageRecipientsService messageRecipientsService);

	/**
	 * Sets the messages service.
	 * 
	 * @param messagesService
	 *            the new messages service
	 */
	void setMessagesService(MessagesService messagesService);

}
