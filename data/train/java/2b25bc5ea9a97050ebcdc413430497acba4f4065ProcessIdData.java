/* Coyright Eric Cariou, 2009 - 2011 */

package service.id;

import communication.ProcessIdentifier;

/**
 * Abstract class containing an identifier process
 */
public abstract class ProcessIdData extends IdentificationData {

    /**
     * The identifier process
     */
    protected ProcessIdentifier processId;

    public ProcessIdentifier getProcessId() {
        return processId;
    }

    public void setProcessId(ProcessIdentifier processId) {
        this.processId = processId;
    }

    public ProcessIdData(ProcessIdentifier processId) {
        this.processId = processId;
    }


}
