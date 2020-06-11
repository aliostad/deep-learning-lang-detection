package bgit.model;

import org.eclipse.jgit.lib.RepositoryState;

public class GitRepositoryState {

    private final RepositoryState repositoryState;

    public GitRepositoryState(RepositoryState repositoryState) {
        this.repositoryState = repositoryState;
    }

    public boolean canPull() {
        return repositoryState == RepositoryState.SAFE;
    }

    public boolean canCommit() {
        return repositoryState != RepositoryState.BARE;
    }

    public boolean canRollback() {
        return repositoryState.canResetHead();
    }

    public boolean canDiscardLastCommit() {
        return repositoryState.canAmend();
    }
}
