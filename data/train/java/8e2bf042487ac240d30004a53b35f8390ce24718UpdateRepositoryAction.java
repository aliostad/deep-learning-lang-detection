package com.surevine.gateway.auditing.action;

import models.Repository;

public class UpdateRepositoryAction implements AuditAction {

	protected Repository originalRepository;
	protected Repository updatedRepository;

	public UpdateRepositoryAction(Repository originalRepository, Repository updatedRepository) {
		this.originalRepository = originalRepository;
		this.updatedRepository = updatedRepository;
	}

	@Override
	public String getDescription() {
		return String.format("Updated repository [%s][%s]",
								updatedRepository.getRepoType(),
								updatedRepository.getIdentifier());
	}

	@Override
	public String serialize() {
		return getDescription();
	}

}
