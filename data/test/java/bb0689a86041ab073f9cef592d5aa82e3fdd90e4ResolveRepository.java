/* Copyright (c) 2013 OpenPlans. All rights reserved.
 * This code is licensed under the BSD New License, available at the root
 * application directory.
 */
package org.geogit.api.plumbing;

import org.geogit.api.AbstractGeoGitOp;
import org.geogit.repository.Repository;

import com.google.inject.Inject;

/**
 * Resolves the current repository
 * 
 */
public class ResolveRepository extends AbstractGeoGitOp<Repository> {

    private Repository repository;

    /**
     * Constructs a new instance of {@code ResolveRepository} with the specified platform.
     * 
     * @param the repository
     */
    @Inject
    public ResolveRepository(Repository repository) {
        this.repository = repository;
    }

    @Override
    public Repository call() {
        return repository;
    }
}
