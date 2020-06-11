package com.payu.ratel.tests.service.tracing;

import com.payu.ratel.Discover;
import com.payu.ratel.Publish;
import com.payu.ratel.context.ProcessContext;

@Publish
public class ProcessIdPassingServiceImpl implements ProcessIdPassingService {

    @Discover
    private ProcessIdTargetService targetService;


    private String processId;

    @Override
    public void passProcessId() {
        this.processId = ProcessContext.getInstance().getProcessIdentifier();
        this.targetService.storeProcessId();
    }

    @Override
    public String getProcessId() {
        return processId;
    }

}
