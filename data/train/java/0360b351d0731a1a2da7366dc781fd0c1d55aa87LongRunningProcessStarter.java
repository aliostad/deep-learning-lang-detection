package com.github.signed.tryanderror.jersey.resources;

import org.joda.time.DateTime;

import javax.inject.Inject;

public class LongRunningProcessStarter {

    private final ProcessArchive archive;

    @Inject
    public LongRunningProcessStarter(ProcessArchive archive) {
        this.archive = archive;
    }

    public ProcessIdentifier start(ProcessInput processInput) {
        ProcessIdentifier processIdentifier = new ProcessIdentifier(new DateTime().getMillis());
        LongRunningProcess newLongRunningProcess = LongRunningProcess.createNewLongRunningProcess(processIdentifier, processInput);
        archive.process(newLongRunningProcess);
        newLongRunningProcess.start();

        return processIdentifier;
    }
}
