
package org.bungeni.trackchanges.process.schema;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Ashok Hariharan
 */
public class ProcessDocuments {
    private List<ProcessDocument> processDocuments = new ArrayList<ProcessDocument>(0);

    /**
     * @return the processDocuments
     */
    public List<ProcessDocument> getProcessDocuments() {
        return processDocuments;
    }

    /**
     * @param processDocuments the processDocuments to set
     */
    public void setProcessDocuments(List<ProcessDocument> processDocuments) {
        this.processDocuments = processDocuments;
    }

    /**
     * 
     * @param processDocument
     */
    public void addProcessDocument(ProcessDocument processDocument) {
        this.processDocuments.add(processDocument);
    }

    public void clear(){
        this.processDocuments.clear();
    }
}
