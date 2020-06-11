package yuki.m.android.architecturesample.presentation.di.module;

import dagger.Module;
import dagger.Provides;
import yuki.m.android.architecturesample.data.repository.GitHubRepositoryRepositoryImpl;
import yuki.m.android.architecturesample.domain.executor.ThreadExecutor;
import yuki.m.android.architecturesample.domain.repository.GitHubRepositoryRepository;
import yuki.m.android.architecturesample.domain.usecase.GetGitHubRepositoryUseCase;
import yuki.m.android.architecturesample.domain.usecase.GetGitHubRepositoryUseCaseImpl;
import yuki.m.android.architecturesample.presentation.di.scope.PerScreen;

@Module
public class GitHubRepositoryModule {

  @Provides @PerScreen GetGitHubRepositoryUseCase provideGetGitHubRepositoryUseCase(
      GitHubRepositoryRepository repository, ThreadExecutor threadExecutor) {
    return new GetGitHubRepositoryUseCaseImpl(repository, threadExecutor);
  }

  @Provides @PerScreen
  GitHubRepositoryRepository provideGitHubRepositoryRepository() {
    return new GitHubRepositoryRepositoryImpl();
  }
}
