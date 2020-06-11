package com.caturday.app.capsules.newpost.interactor;

import com.caturday.app.models.catpost.CatPostEntity;
import com.caturday.app.models.catpost.repository.CatPostRepository;
import com.caturday.app.models.user.repository.UserRepository;

import rx.Observable;

public class NewPostInteractorImpl implements NewPostInteractor {

    private final CatPostRepository catPostRepository;
    private final UserRepository userRepository;

    public NewPostInteractorImpl(UserRepository userRepository,
                                 CatPostRepository catPostRepository) {
        this.userRepository = userRepository;
        this.catPostRepository = catPostRepository;
    }

    @Override
    public Observable<CatPostEntity> createPost(CatPostEntity catPostEntity) {
        return catPostRepository.createPost(catPostEntity);
    }
}
