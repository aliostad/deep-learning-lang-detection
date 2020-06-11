package com.redhat.qe.helpers.repository;

import com.redhat.qe.model.Host;
import com.redhat.qe.model.WaitUtil;
import com.redhat.qe.repository.rest.HostRepository;

public class HostRepositoryHelper {

	private static final int HOST_UP_WAIT_ATTEMPT = 25;
	private HostRepository repository;
	
	
	public HostRepositoryHelper(HostRepository repository){
		this.repository = repository;
	}

	
	public boolean waitForHostUp(Host host){
		return WaitUtil.waitForHostStatus(repository, host, "up", HOST_UP_WAIT_ATTEMPT);
	}
}
