/**
 * 
 */
package com.redhat.qe.storageconsole.helpers.fixtures;

import org.calgb.test.performance.HttpSession;

import com.redhat.qe.ovirt.shell.RhscShellSession;
import com.redhat.qe.repository.IClusterRepository;
import com.redhat.qe.repository.IHostRepository;
import com.redhat.qe.repository.IVolumeRepositoryFactory;
import com.redhat.qe.repository.rhscshell.ClusterRepository;
import com.redhat.qe.repository.rhscshell.HostRepository;
import com.redhat.qe.repository.rhscshell.VolumeRepositoryFactory;

/**
 * @author dustin 
 * Oct 3, 2013
 */
public class RepositoryContainer {
	private IHostRepository hostRepository;
	private IClusterRepository clusterRepository;
	private IVolumeRepositoryFactory volumeRepositoryFactory;
	/**
	 * @return the hostRepository
	 */
	public IHostRepository getHostRepository() {
		return this.hostRepository;
	}

	public static RepositoryContainer getRepositoryContainer(RhscShellSession session){
		return new RepositoryContainer(new HostRepository(session), new VolumeRepositoryFactory(session), new ClusterRepository(session));
		
	}
	/**
	 * @param hostRepository the hostRepository to set
	 */
	public void setHostRepository(IHostRepository hostRepository) {
		this.hostRepository = hostRepository;
	}
	/**
	 * @return the clusterRepository
	 */
	public IClusterRepository getClusterRepository() {
		return this.clusterRepository;
	}
	/**
	 * @param clusterRepository the clusterRepository to set
	 */
	public void setClusterRepository(IClusterRepository clusterRepository) {
		this.clusterRepository = clusterRepository;
	}
	
	
	/**
	 * @return the volumeRepositoryFactory
	 */
	public IVolumeRepositoryFactory getVolumeRepositoryFactory() {
		return this.volumeRepositoryFactory;
	}

	/**
	 * @param hostRepository
	 * @param volumeRepositoryFactory2 
	 * @param volumeRepository
	 * @param clusterRepository
	 */
	public RepositoryContainer(IHostRepository hostRepository,
			IVolumeRepositoryFactory volumeRepositoryFactory, 
			IClusterRepository clusterRepository) {
		super();
		this.hostRepository = hostRepository;
		this.clusterRepository = clusterRepository;
		this.volumeRepositoryFactory = volumeRepositoryFactory;
	}

	/**
	 * @param session
	 * @return
	 */
	public static RepositoryContainer getRepositoryContainer(HttpSession session) {
		return new RepositoryContainer(new com.redhat.qe.repository.rest.HostRepository(session),new com.redhat.qe.repository.rest.VolumeRepositoryFactory(session),  new com.redhat.qe.repository.rest.ClusterRepository(session));
	}

}
