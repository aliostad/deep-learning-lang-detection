package com.carrotgarden.nexus.example.scanner;

import javax.inject.Inject;
import javax.inject.Named;

import org.sonatype.configuration.ConfigurationException;
import org.sonatype.nexus.plugins.RepositoryCustomizer;
import org.sonatype.nexus.proxy.repository.ProxyRepository;
import org.sonatype.nexus.proxy.repository.Repository;
import org.sonatype.nexus.proxy.repository.RequestProcessor;

public class ScannerRepositoryCustomizer implements RepositoryCustomizer {

	@Inject
	@Named(ScannerRequestProcessor.NAME)
	private RequestProcessor processor;

	@Override
	public boolean isHandledRepository(final Repository repository) {

		// handle proxy reposes only

		return repository.getRepositoryKind().isFacetAvailable(
				ProxyRepository.class);

	}

	@Override
	public void configureRepository(final Repository repository)
			throws ConfigurationException {

		repository.getRequestProcessors().put( //
				ScannerRequestProcessor.NAME, processor);

	}

}
