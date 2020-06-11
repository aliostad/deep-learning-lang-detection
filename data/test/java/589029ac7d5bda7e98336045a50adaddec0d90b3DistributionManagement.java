package org.injava.build.cutebuild.maven.pom.elements.distributionmanagement;

import static java.util.Arrays.asList;
import static org.injava.lang.designbycontract.Preconditions.requireNonNull;

import java.util.List;

import org.injava.build.cutebuild.maven.pom.PomElement;
import org.injava.build.cutebuild.maven.pom.elements.base.BaseContainer;

public class DistributionManagement extends BaseContainer {
	private final SnapshotRepository snapshotRepository;
	private final Repository repository;

	
	public DistributionManagement(SnapshotRepository snapshotRepository,
			Repository repository) {
		requireNonNull(snapshotRepository);
		requireNonNull(repository);
		this.snapshotRepository = snapshotRepository;
		this.repository = repository;
	}


	public List<? extends PomElement> getContent() {
		return asList(snapshotRepository, repository);
	}

}
