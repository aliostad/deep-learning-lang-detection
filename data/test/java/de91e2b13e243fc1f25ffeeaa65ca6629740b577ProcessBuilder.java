package com.gduranti.processengine.util;

import com.gduranti.processengine.model.Process;
import com.gduranti.processengine.model.ProcessInstance;
import com.gduranti.processengine.model.ProcessStatus;
import com.gduranti.processengine.model.ProcessType;
import com.gduranti.processengine.model.ProcessTypeVersion;

public class ProcessBuilder {

    public Process buildProcess(ProcessType processType) {

        ProcessTypeVersion processTypeVersion = processType.getCurrentVersion();
        Process process = new Process(processTypeVersion, ProcessStatus.ABERTO);
        process.addInstance(new ProcessInstance(process, processTypeVersion.getInitialStep()));

        // TODO

        return process;
    }

}
