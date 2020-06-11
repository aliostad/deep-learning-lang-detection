package com.michael.attackpoint.discussion;

import com.michael.attackpoint.discussion.data.DiscussionRepository;
import com.michael.attackpoint.discussion.data.DiscussionRepositoryImpl;

/**
 * Created by michael on 5/5/16.
 */
public class DiscussionRepositories {

    private DiscussionRepositories() {
        // no instance
    }

    private static DiscussionRepository repository = null;

    public synchronized static DiscussionRepository getRepoInstance() {
        if (repository == null) {
            repository = new DiscussionRepositoryImpl();
        }
        return repository;
    }
}
