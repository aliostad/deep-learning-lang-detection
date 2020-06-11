package com.pars.nli.marc;

import com.pars.marc.batch.BatchProcess;


/**
 * Created by IntelliJ IDEA.
 * User: javidnia
 * Date: Jan 3, 2006
 * Time: 10:47:25 AM
 * Any object who wished to receive batch update process state change notifications
 */
public interface BatchProcessClient {
    /**
     * notifies current process state
     * @param process the process whose state ios being informed
     */
    void notifyProcessState(BatchProcess process);

    /**
     * process has been started
     */
    void notifyStart();

    /**
     * process has been stopped
     */
    void notifyStop();
}
