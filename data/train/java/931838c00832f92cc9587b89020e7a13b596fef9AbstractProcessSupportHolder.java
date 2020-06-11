package org.cucina.engine.server.handlers;

import org.springframework.util.Assert;

import org.cucina.engine.service.ProcessSupportService;


/**
 *
 *
 * @author vlevine
  *
 * @param <T> .
 */
public abstract class AbstractProcessSupportHolder {
    private ProcessSupportService processSupportService;

    /**
    * Creates a new AbstractProcessSupportHandler object.
    *
    * @param processSupportService .
    */
    public AbstractProcessSupportHolder(ProcessSupportService processSupportService) {
        Assert.notNull(processSupportService, "processSupportService is null");
        this.processSupportService = processSupportService;
    }

    
    /**
     *
     *
     * @return .
     */
    protected ProcessSupportService getProcessSupportService() {
        return processSupportService;
    }
}
