/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.pieShare.pieShareApp.springConfiguration.PieShareApp;

import org.apache.commons.vfs2.impl.DefaultFileMonitor;
import org.pieShare.pieShareApp.model.pieFile.PieFile;
import org.pieShare.pieShareApp.service.PieShareService;
import org.pieShare.pieShareApp.service.comparerService.ALocalFileCompareService;
import org.pieShare.pieShareApp.service.comparerService.FileCompareService;
import org.pieShare.pieShareApp.service.comparerService.FileHistoryCompareService;
import org.pieShare.pieShareApp.service.comparerService.api.ILocalFileCompareService;
import org.pieShare.pieShareApp.service.configurationService.ApplicationConfigurationService;
import org.pieShare.pieShareApp.service.configurationService.ConfigurationFactory;
import org.pieShare.pieShareApp.service.database.DatabaseService;
import org.pieShare.pieShareApp.service.database.ModelEntityConverterService;
import org.pieShare.pieShareApp.service.database.PieDatabaseManagerFactory;
import org.pieShare.pieShareApp.service.factoryService.MessageFactoryService;
import org.pieShare.pieShareApp.service.fileFilterService.FileFilterService;
import org.pieShare.pieShareApp.service.fileFilterService.filters.RegexFileFilter;
import org.pieShare.pieShareApp.service.fileService.FileServiceBase;
import org.pieShare.pieShareApp.service.fileService.HistoryFileService;
import org.pieShare.pieShareApp.service.fileService.LocalFileService;
import org.pieShare.pieShareApp.service.fileService.fileEncryptionService.FileEncryptionService;
import org.pieShare.pieShareApp.service.fileService.fileListenerService.ApacheDefaultFileListener;
import org.pieShare.pieShareApp.service.fileService.fileListenerService.ApacheFileWatcherService;
import org.pieShare.pieShareApp.service.historyService.HistoryService;
import org.pieShare.pieShareApp.service.networkService.NetworkService;
import org.pieShare.pieShareApp.service.requestService.RequestService;
import org.pieShare.pieShareApp.service.shareService.BitTorrentService;
import org.pieShare.pieShareApp.service.shareService.ShareService;
import org.pieShare.pieShareApp.springConfiguration.PiePlateConfiguration;
import org.pieShare.pieShareApp.springConfiguration.PieUtilitiesConfiguration;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Lazy;
import org.springframework.context.annotation.Scope;

/**
 *
 * @author Svetoslav
 */
@Configuration
public class PieShareAppService {

	@Autowired
	protected PieUtilitiesConfiguration utilities;
	@Autowired
	protected PiePlateConfiguration plate;

	@Bean
	@Lazy
	@Scope(value = "prototype")
	public PieFile pieFile() {
		return new PieFile();
	}

	@Bean
	public PieShareService pieShareService() {
		PieShareService service = new PieShareService();
		service.setExecutorFactory(this.utilities.pieExecutorTaskFactory());
		service.setClusterManagementService(this.plate.clusterManagementService());
		service.setShutdownService(this.utilities.shutdownService());
		service.setDatabaseService(databaseService());
		service.setConfigurationFactory(this.configurationFactory());
		service.setBeanService(utilities.beanService());
		service.start();
		return service;
	}

	@Bean
	@Scope(value = "prototype")
	public DefaultFileMonitor defaultFileMonitor() {
		DefaultFileMonitor filelistener = new DefaultFileMonitor(fileListenerService());
		return filelistener;
	}

	@Bean
	@Lazy
	public NetworkService networkService() {
		return new NetworkService();
	}

	@Bean
	@Lazy
	public ApplicationConfigurationService applicationConfigurationService() {
		ApplicationConfigurationService service = new ApplicationConfigurationService();
		service.setPropertiesReader(utilities.configurationReader());
		service.setBeanService(utilities.beanService());
		service.init();
		return service;
	}

	@Bean
	@Lazy
	public MessageFactoryService messageFactoryService() {
		MessageFactoryService service = new MessageFactoryService();
		return service;
	}

	@Bean
	@Lazy
	public RequestService requestService() {
		RequestService service = new RequestService();
		service.setBeanService(this.utilities.beanService());
		service.setClusterManagementService(this.plate.clusterManagementService());
		service.setMessageFactoryService(this.messageFactoryService());
		return service;
	}

	@Bean
	@Lazy
	public FileEncryptionService fileEncryptionService() {
		FileEncryptionService service = new FileEncryptionService();
		service.setFileService(this.localFileService());
		service.setProviderService(this.utilities.providerService());
		service.setBeanService(this.utilities.beanService());
		return service;
	}

	@Bean
	@Lazy
	public ILocalFileCompareService fileCompareService() {
		FileCompareService service = new FileCompareService();
		service.setFileService(this.localFileService());
		service.setWrappedCompareService(this.historyCompareServicePrivate());
		return service;
	}

	@Bean
	@Lazy
	public ILocalFileCompareService historyCompareService() {
		return this.historyCompareServicePrivate();
	}

	@Bean
	@Lazy
	protected ALocalFileCompareService historyCompareServicePrivate() {
		FileHistoryCompareService historyService = new FileHistoryCompareService();
		historyService.setHistoryService(this.historyFileService());
		return historyService;
	}

	@Bean
	@Lazy
	@Scope(value = "prototype")
	public ApacheDefaultFileListener fileListenerService() {
		ApacheDefaultFileListener listener = new ApacheDefaultFileListener();
		listener.setBeanService(this.utilities.beanService());
		listener.setExecutorService(this.utilities.pieExecutorService());
		return listener;
	}

	@Bean
	@Lazy
	public ApacheFileWatcherService apacheFileWatcherService() {
		ApacheFileWatcherService watcher = new ApacheFileWatcherService();
		watcher.setBeanService(this.utilities.beanService());
		watcher.setShutdownService(this.utilities.shutdownService());
		watcher.init();
		return watcher;
	}

	private void fileServiceBase(FileServiceBase base) {
		base.setBeanService(this.utilities.beanService());
		base.setFileWatcherService(this.apacheFileWatcherService());
		base.init();
	}

	@Bean
	@Lazy
	public LocalFileService localFileService() {
		LocalFileService service = new LocalFileService();
		this.fileServiceBase(service);
		service.setHashService(this.utilities.md5Service());
		return service;
	}

	@Bean
	@Lazy
	public HistoryFileService historyFileService() {
		HistoryFileService service = new HistoryFileService();
		this.fileServiceBase(service);
		service.setDatabaseService(this.databaseService());
		return service;
	}

	@Bean
	@Lazy
	public HistoryService historyService() {
		HistoryService service = new HistoryService();
		service.setDatabaseService(this.databaseService());
		service.setFileService(this.localFileService());
		return service;
	}

	@Bean
	@Lazy
	public BitTorrentService bitTorrentService() {
		BitTorrentService service = new BitTorrentService();
		service.setBeanService(this.utilities.beanService());
		service.setNetworkService(this.networkService());
		service.setExecutorService(this.utilities.pieExecutorService());
		service.setBase64Service(this.utilities.base64Service());

		service.initTorrentService();
		return service;
	}

	@Bean
	@Lazy
	public ShareService shareService() {
		ShareService service = new ShareService();
		service.setFileEncryptionService(this.fileEncryptionService());
		service.setFileWatcherService(this.apacheFileWatcherService());
		service.setComparerService(this.fileCompareService());
		service.setFileService(this.localFileService());

		service.init();
		return service;
	}

	@Bean
	@Lazy
	public DatabaseService databaseService() {
		DatabaseService service = new DatabaseService();
		service.setBase64Service(utilities.base64Service());
		service.setBeanService(utilities.beanService());
		service.setPieDatabaseManagerFactory(pieDatabaseManagerFactory());
		service.setConfigurationFactory(configurationFactory());
		service.setModelEntityConverterService(modelEntityConverterService());
		return service;
	}

	public ModelEntityConverterService modelEntityConverterService() {
		ModelEntityConverterService service = new ModelEntityConverterService();
		service.setBeanService(utilities.beanService());
		return service;
	}

	@Bean
	@Lazy
	public PieDatabaseManagerFactory pieDatabaseManagerFactory() {
		PieDatabaseManagerFactory fac = new PieDatabaseManagerFactory();
		fac.setApplicationConfigurationService(applicationConfigurationService());
		fac.setShutdownService(this.utilities.shutdownService());
		return fac;
	}

	@Bean
	@Lazy
	public FileFilterService fileFilterService() {
		FileFilterService filter = new FileFilterService();
		filter.setDatabaseService(databaseService());
		return filter;
	}

	@Bean
	@Lazy
	@Scope(value = "prototype")
	public RegexFileFilter fileFilter() {
		RegexFileFilter filter = new RegexFileFilter();
		filter.setRegexService(utilities.regexService());
		return filter;
	}

	@Bean
	@Lazy
	public ConfigurationFactory configurationFactory() {
		ConfigurationFactory service = new ConfigurationFactory();
		service.setApplicationConfiguration(applicationConfigurationService());
		service.setBeanService(utilities.beanService());
		return service;
	}

}
