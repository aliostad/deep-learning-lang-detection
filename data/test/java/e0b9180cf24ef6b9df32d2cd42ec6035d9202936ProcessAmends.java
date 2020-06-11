package org.bungeni.trackchanges.process.schema;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Ashok Hariharan
 */
public class ProcessAmends {
    private List<ProcessAmend> processAmends = new ArrayList<ProcessAmend>(0);

    /**
     * @return the processAmends
     */
    public List<ProcessAmend> getProcessAmends() {
        return processAmends;
    }

    /**
     * @param processAmends the processAmends to set
     */
    public void setProcessAmends(List<ProcessAmend> processAmends) {
        this.processAmends = processAmends;
    }

    public void addProcessAmend(ProcessAmend pAmend) {
        this.processAmends.add(pAmend);
    }

    public void clear() {
        this.processAmends.clear();
    }

}
