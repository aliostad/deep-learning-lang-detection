package com.bretth.osmosis.git_migration;

import java.util.HashMap;
import java.util.Map;


public class RevisionMapper {
	private Map<String, RepositoryRevisionMapper> repositoryMappers;
	private int maxTargetRevision;


	public RevisionMapper() {
		repositoryMappers = new HashMap<String, RepositoryRevisionMapper>();
		maxTargetRevision = 0;
	}


	public int addRevision(String repository, int sourceRevision) {
		maxTargetRevision++;

		if (!repositoryMappers.containsKey(repository)) {
			repositoryMappers.put(repository, new RepositoryRevisionMapper(repository));
		}

		repositoryMappers.get(repository).addRevision(new MappedRevision(sourceRevision, maxTargetRevision));
		
		return maxTargetRevision;
	}


	public int getTargetRevision(String repository, int sourceRevision) {
		return repositoryMappers.get(repository).getTargetRevision(sourceRevision);
	}
}
