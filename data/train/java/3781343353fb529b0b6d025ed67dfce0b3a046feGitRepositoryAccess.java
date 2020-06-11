package com.link_intersystems.gitdirstat.domain;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.eclipse.jgit.lib.Repository;
import org.eclipse.jgit.storage.file.FileRepositoryBuilder;

public class GitRepositoryAccess {

	private Map<String, GitRepository> repositoryData = new HashMap<String, GitRepository>();

	public GitRepository getGitRepository(File repositoryDirectory) {
		String repositoryId = GitRepository.createId(repositoryDirectory);
		GitRepository gitRepository = repositoryData.get(repositoryId);
		if (gitRepository == null) {
			FileRepositoryBuilder builder = new FileRepositoryBuilder();
			builder.readEnvironment();
			builder.findGitDir(repositoryDirectory);

			try {
				Repository repository = builder.build();
				gitRepository = new GitRepository(repository);
				repositoryData.put(gitRepository.getId(), gitRepository);
			} catch (IOException e) {
				throw new IllegalStateException(e);
			}
		}

		return gitRepository;
	}
}
