package com.github.athieriot.android.travisci.core.entity;

import org.joda.time.DateTime;
import org.junit.Test;

import static org.junit.Assert.assertTrue;

public class RepositoryTest {

    @Test
    public void testCompareToShowRecentRepositoryFirst() throws Exception {
        Repository repositoryBefore = new Repository();
        repositoryBefore.setLast_build_started_at(new DateTime());

        Repository repositoryAfter = new Repository();
        repositoryAfter.setLast_build_started_at(new DateTime().plus(200));

        assertTrue(repositoryAfter.compareTo(repositoryBefore) < 0);
    }

    @Test
    public void testCompareToShowNonNullRepositoryFirst() throws Exception {
        Repository repository = new Repository();
        repository.setLast_build_started_at(new DateTime());

        Repository nullRepository = new Repository();

        assertTrue(repository.compareTo(nullRepository) < 0);
    }
}
