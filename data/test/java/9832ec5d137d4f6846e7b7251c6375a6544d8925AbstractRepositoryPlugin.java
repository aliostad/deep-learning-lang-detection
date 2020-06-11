package ca.uhnresearch.pughlab.tracker.plugins;

import org.springframework.beans.factory.annotation.Required;

import ca.uhnresearch.pughlab.tracker.dao.StudyRepository;
import ca.uhnresearch.pughlab.tracker.events.EventHandler;

public abstract class AbstractRepositoryPlugin implements EventHandler {
	private StudyRepository repository;

	@Required
    public void setRepository(StudyRepository repository) {
        this.repository = repository;
    }
	
	public StudyRepository getRepository() {
		return repository;
	}

}
