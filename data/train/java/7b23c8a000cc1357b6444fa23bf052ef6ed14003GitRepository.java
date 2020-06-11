package org.arnolds.agileappproject.agileappmodule.git.wrappers;

import org.kohsuke.github.GHRepository;

public class GitRepository {
    private GHRepository apiRepository;

    public GitRepository() {}

    public GitRepository(GHRepository apiRepository) {
        this.apiRepository = apiRepository;
    }

    @Override
    public boolean equals(Object o) {
        if(o != null && o instanceof GitRepository) {
            GitRepository otherRepository = (GitRepository) o;
            return (getName().equals(otherRepository.getName()) &&
                        getUrl().equals(otherRepository.getUrl()));
        }

        return false;
    }

    @Override
    public int hashCode() {
        return getName().hashCode()*apiRepository.getUrl().hashCode()*39;
    }

    @Override
    public String toString() {
        return super.toString();
    }

    public String getName() {
        return apiRepository.getName();
    }

    public String getUrl() {
        return apiRepository.getUrl();
    }


}
