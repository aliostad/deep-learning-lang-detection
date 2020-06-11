package com.zenika.dorm.maven.importer.core;

import org.apache.maven.repository.internal.DefaultServiceLocator;
import org.apache.maven.repository.internal.MavenRepositorySystemSession;
import org.sonatype.aether.RepositorySystem;
import org.sonatype.aether.RepositorySystemSession;
import org.sonatype.aether.connector.file.FileRepositoryConnectorFactory;
import org.sonatype.aether.connector.wagon.WagonProvider;
import org.sonatype.aether.connector.wagon.WagonRepositoryConnectorFactory;
import org.sonatype.aether.repository.LocalRepository;
import org.sonatype.aether.repository.RemoteRepository;
import org.sonatype.aether.spi.connector.RepositoryConnectorFactory;

import com.zenika.dorm.maven.importer.util.ConsoleRepositoryListener;
import com.zenika.dorm.maven.importer.util.ConsoleTransferListener;

public class MavenRepositoryFactory {

	public static RepositorySystem createRepositorySystem() {

		DefaultServiceLocator locator = new DefaultServiceLocator();

		locator.addService(RepositoryConnectorFactory.class,
				FileRepositoryConnectorFactory.class);
		locator.addService(RepositoryConnectorFactory.class,
				WagonRepositoryConnectorFactory.class);

		locator.setServices(WagonProvider.class, new MavenImporterWagonProvider());

		return locator.getService(RepositorySystem.class);
	}

	public static RepositorySystemSession createRepositorySystemSession(
			RepositorySystem system) {

		MavenRepositorySystemSession session = new MavenRepositorySystemSession();

		LocalRepository localRepo = new LocalRepository("target/local-repo");
		session.setLocalRepositoryManager(system
				.newLocalRepositoryManager(localRepo));

		session.setTransferListener(new ConsoleTransferListener());
		session.setRepositoryListener(new ConsoleRepositoryListener());

		return session;
	}

	public static RemoteRepository createRemoteRepository() {
		return new RemoteRepository("central", "default",
				"http://repo1.maven.org/maven2/");
	}
}
