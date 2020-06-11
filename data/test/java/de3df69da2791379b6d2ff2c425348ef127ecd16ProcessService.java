package org.helianto.document;

import org.helianto.document.model.ProcessDocumentModel;

/**
 * Remote service interface to process.
 * 
 * @author mauriciofernandesdecastro
 */
public interface ProcessService {
	
	/**
	 * Find process document.
	 * 
	 * @param entityAlias
	 * @param docCode
	 */
	ProcessDocumentModel findProcessDocument(String entityAlias, String docCode);
	
	/**
	 * Create process document.
	 * 
	 * @param processDocument
	 * @param auth
	 */
	int createProcessDocument(ProcessDocumentModel processDocument, String auth);
	
}
