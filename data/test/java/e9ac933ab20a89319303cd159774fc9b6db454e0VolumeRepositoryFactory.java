/**
 * 
 */
package com.redhat.qe.repository.rest;

import org.calgb.test.performance.HttpSession;

import com.redhat.qe.model.Cluster;
import com.redhat.qe.repository.IVolumeRepository;
import com.redhat.qe.repository.IVolumeRepositoryFactory;
import com.redhat.qe.repository.rest.VolumeRepository;

/**
 * @author dustin 
 * Oct 16, 2013
 */
public class VolumeRepositoryFactory implements IVolumeRepositoryFactory {

	private HttpSession session;

	/**
	 * @param session
	 */
	public VolumeRepositoryFactory(HttpSession session) {
		this.session = session;
		
	}

	/* (non-Javadoc)
	 * @see com.redhat.qe.repository.IVolumeRepositoryFactory#getVolumeRepository(com.redhat.qe.model.Cluster)
	 */
	public IVolumeRepository getVolumeRepository(Cluster cluster) {
		return new VolumeRepository(session, cluster);
	}

}
