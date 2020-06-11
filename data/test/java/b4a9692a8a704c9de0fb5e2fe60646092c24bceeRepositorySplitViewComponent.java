package info.mschmitt.githubbrowser.app.dagger;

import dagger.Subcomponent;
import info.mschmitt.githubbrowser.ui.fragments.RepositoryListViewFragment;
import info.mschmitt.githubbrowser.ui.fragments.RepositoryPagerViewFragment;
import info.mschmitt.githubbrowser.ui.fragments.RepositorySplitViewFragment;
import info.mschmitt.githubbrowser.ui.scopes.RepositorySplitViewScope;

/**
 * @author Matthias Schmitt
 */
@RepositorySplitViewScope
@Subcomponent(modules = {RepositorySplitViewModule.class})
abstract class RepositorySplitViewComponent implements RepositorySplitViewFragment.Component {
    @Override
    public RepositoryListViewComponent repositoryListViewComponent(
            RepositoryListViewFragment fragment) {
        return repositoryListViewComponent(new RepositoryListViewModule());
    }

    @Override
    public RepositoryPagerViewComponent repositoryPagerViewComponent(
            RepositoryPagerViewFragment fragment) {
        return repositoryPagerViewComponent(new RepositoryPagerViewModule(fragment));
    }

    abstract RepositoryPagerViewComponent repositoryPagerViewComponent(
            RepositoryPagerViewModule module);

    abstract RepositoryListViewComponent repositoryListViewComponent(
            RepositoryListViewModule module);
}
