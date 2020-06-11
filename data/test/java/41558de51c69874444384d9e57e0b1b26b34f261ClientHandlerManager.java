package de.hsrm.perfunctio.core.client.handler;

import org.eclipse.scout.commons.exception.ProcessingException;

import de.hsrm.perfunctio.core.shared.handler.AbstractHandlerManager;

/**
 * Handler container for managing all client handler. Activates the handler
 * chain
 * 
 * @author Mirjam Bayatloo
 * 
 */
public class ClientHandlerManager extends AbstractHandlerManager {

	private FileChooserFormHandler fileChooserFormHandler;
	private DroppedFileMetadataHandler droppedFileMetadataHander;
	private UnknownFileformatHandler unknownFileFormatHandler;
	private MultipleFiletypesHandler multipleFiletypesHandler;
	private FileDataHandler fileDataHandler;

	public ClientHandlerManager() {
		super();

		fileChooserFormHandler = new FileChooserFormHandler();
		droppedFileMetadataHander = new DroppedFileMetadataHandler();
		unknownFileFormatHandler = new UnknownFileformatHandler();
		multipleFiletypesHandler = new MultipleFiletypesHandler();
		fileDataHandler = new FileDataHandler();

		fileChooserFormHandler.setNext(droppedFileMetadataHander);
		droppedFileMetadataHander.setNext(unknownFileFormatHandler);
		unknownFileFormatHandler.setNext(multipleFiletypesHandler);
		multipleFiletypesHandler.setNext(fileDataHandler);

		handler.add(fileChooserFormHandler);
		handler.add(droppedFileMetadataHander);
		handler.add(unknownFileFormatHandler);
		handler.add(multipleFiletypesHandler);
		handler.add(fileDataHandler);
	}

	/**
	 * @return the fileChooserFormHandler
	 */
	public FileChooserFormHandler getFileChooserFormHandler() {
		return fileChooserFormHandler;
	}

	/**
	 * @return the droppedFileMetadataHander
	 */
	public DroppedFileMetadataHandler getDroppedFileMetadataHander() {
		return droppedFileMetadataHander;
	}

	/**
	 * @return the unknownFileFormatHandler
	 */
	public UnknownFileformatHandler getUnknownFileFormatHandler() {
		return unknownFileFormatHandler;
	}

	/**
	 * @return the multipleFiletypesHandler
	 */
	public MultipleFiletypesHandler getMultipleFiletypesHandler() {
		return multipleFiletypesHandler;
	}

	/**
	 * @return the fileDataHandler
	 */
	public FileDataHandler getFileDataHandler() {
		return fileDataHandler;
	}

	public void handle(FileUploadData data) throws ProcessingException {
		((AbstractClientHandler) handler.get(0)).handle(data);
	}

}
