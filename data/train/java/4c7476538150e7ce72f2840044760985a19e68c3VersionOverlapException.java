package com.redhat.repository.validator.impl.version;

import org.eclipse.aether.repository.RemoteRepository;

public class VersionOverlapException extends Exception {

    private static final long serialVersionUID = 1L;

    private final String gav;
    private final RemoteRepository remoteRepository;

    public VersionOverlapException(String gav, RemoteRepository remoteRepository) {
        super("Artifact " + gav + " has overlap with remote repository: " + remoteRepository);
        this.gav = gav;
        this.remoteRepository = remoteRepository;
    }

    public String getGav() {
        return gav;
    }

    public RemoteRepository getRemoteRepository() {
        return remoteRepository;
    }

}