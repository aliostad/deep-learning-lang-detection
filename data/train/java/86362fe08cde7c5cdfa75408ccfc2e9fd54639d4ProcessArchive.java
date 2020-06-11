package com.github.signed.tryanderror.jersey.resources;

import com.google.common.collect.Maps;

import java.util.Map;

public class ProcessArchive {
    private final Map<ProcessIdentifier, LongRunningProcess> processes = Maps.newHashMap();

    public void process(LongRunningProcess process) {
        processes.put(process.identifier, process);
    }

    public void eachProcess(Callback<LongRunningProcess> callback) {
        for (LongRunningProcess process : processes.values()) {
            callback.call(process);
        }
    }
}
