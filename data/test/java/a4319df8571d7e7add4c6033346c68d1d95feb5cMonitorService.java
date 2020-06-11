/*
 * Copyright (c) 2005-2012 www.china-cti.com All rights reserved
 * Info:rebirth-search-core MonitorService.java 2012-7-6 14:30:32 l.xue.nong$$
 */

package cn.com.rebirth.core.monitor;

import cn.com.rebirth.commons.component.AbstractLifecycleComponent;
import cn.com.rebirth.commons.exception.RebirthException;
import cn.com.rebirth.commons.settings.Settings;
import cn.com.rebirth.core.inject.Inject;
import cn.com.rebirth.core.monitor.fs.FsService;
import cn.com.rebirth.core.monitor.jvm.JvmMonitorService;
import cn.com.rebirth.core.monitor.jvm.JvmService;
import cn.com.rebirth.core.monitor.network.NetworkService;
import cn.com.rebirth.core.monitor.os.OsService;
import cn.com.rebirth.core.monitor.process.ProcessService;

/**
 * The Class MonitorService.
 *
 * @author l.xue.nong
 */
public class MonitorService extends AbstractLifecycleComponent<MonitorService> {

	/** The jvm monitor service. */
	private final JvmMonitorService jvmMonitorService;

	/** The os service. */
	private final OsService osService;

	/** The process service. */
	private final ProcessService processService;

	/** The jvm service. */
	private final JvmService jvmService;

	/** The network service. */
	private final NetworkService networkService;

	/** The fs service. */
	private final FsService fsService;

	/**
	 * Instantiates a new monitor service.
	 *
	 * @param settings the settings
	 * @param jvmMonitorService the jvm monitor service
	 * @param osService the os service
	 * @param processService the process service
	 * @param jvmService the jvm service
	 * @param networkService the network service
	 * @param fsService the fs service
	 */
	@Inject
	public MonitorService(Settings settings, JvmMonitorService jvmMonitorService, OsService osService,
			ProcessService processService, JvmService jvmService, NetworkService networkService, FsService fsService) {
		super(settings);
		this.jvmMonitorService = jvmMonitorService;
		this.osService = osService;
		this.processService = processService;
		this.jvmService = jvmService;
		this.networkService = networkService;
		this.fsService = fsService;
	}

	/**
	 * Os service.
	 *
	 * @return the os service
	 */
	public OsService osService() {
		return this.osService;
	}

	/**
	 * Process service.
	 *
	 * @return the process service
	 */
	public ProcessService processService() {
		return this.processService;
	}

	/**
	 * Jvm service.
	 *
	 * @return the jvm service
	 */
	public JvmService jvmService() {
		return this.jvmService;
	}

	/**
	 * Network service.
	 *
	 * @return the network service
	 */
	public NetworkService networkService() {
		return this.networkService;
	}

	/**
	 * Fs service.
	 *
	 * @return the fs service
	 */
	public FsService fsService() {
		return this.fsService;
	}

	/* (non-Javadoc)
	 * @see cn.com.rebirth.search.commons.component.AbstractLifecycleComponent#doStart()
	 */
	@Override
	protected void doStart() throws RebirthException {
		jvmMonitorService.start();
	}

	/* (non-Javadoc)
	 * @see cn.com.rebirth.search.commons.component.AbstractLifecycleComponent#doStop()
	 */
	@Override
	protected void doStop() throws RebirthException {
		jvmMonitorService.stop();
	}

	/* (non-Javadoc)
	 * @see cn.com.rebirth.search.commons.component.AbstractLifecycleComponent#doClose()
	 */
	@Override
	protected void doClose() throws RebirthException {
		jvmMonitorService.close();
	}

}
