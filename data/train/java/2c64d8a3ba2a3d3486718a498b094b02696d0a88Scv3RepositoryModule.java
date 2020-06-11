package ru.scv3.repository;

import com.google.inject.AbstractModule;
import ru.scv3.repository.stub.StubCommentRepository;
import ru.scv3.repository.stub.StubPostRepository;
import ru.scv3.repository.stub.StubUserRepository;

/**
 * @author sss3
 */
public class Scv3RepositoryModule extends AbstractModule {
    @Override
    protected void configure() {
        bind(PostRepository.class).to(StubPostRepository.class);
        bind(CommentRepository.class).to(StubCommentRepository.class);
        bind(UserRepository.class).to(StubUserRepository.class);
    }
}
