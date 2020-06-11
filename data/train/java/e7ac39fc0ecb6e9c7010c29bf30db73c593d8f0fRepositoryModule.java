package com.taxsee.data.repository;

import com.taxsee.data.repository.auth.AuthRepositoryImpl;
import com.taxsee.data.repository.content.CommonContentRepositoryImpl;
import com.taxsee.domain.repository.AuthRepository;
import com.taxsee.domain.repository.CommonContentRepository;

import dagger.Module;
import dagger.Provides;


/**
 * Created by Marat Duisenov on 23.02.2017.
 */

@Module(
        complete = false,
        library = true
)
public class RepositoryModule {

    @Provides
    CommonContentRepository provideCommonContentRepository(CommonContentRepositoryImpl repository) {
        return repository;
    }

    @Provides
    AuthRepository provideAuthRepository(AuthRepositoryImpl authRepository) {
        return authRepository;
    }
}
