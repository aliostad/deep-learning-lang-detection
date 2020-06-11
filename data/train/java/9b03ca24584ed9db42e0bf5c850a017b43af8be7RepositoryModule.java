package com.nickdelnano.shake2log.DI;

import android.app.Application;

import com.nickdelnano.shake2log.repository.RealmRepository;
import com.nickdelnano.shake2log.repository.Repository;
import com.nickdelnano.shake2log.repository.SQLiteRepository;


import javax.inject.Singleton;

import dagger.Module;
import dagger.Provides;

/**
 * Created by nickdelnano on 1/7/16.
 */
@Module
public class RepositoryModule
{
    @Provides
    @Singleton
    Repository provideRepository(Application application) {
            return new SQLiteRepository(application);
    }
}
