package com.coatedmoose.daggerizedandroid;

import android.app.Service;
import android.content.Context;

import com.coatedmoose.daggerizedandroid.qualifier.ForService;

import dagger.Module;
import dagger.Provides;

@Module(
        addsTo = ApplicationModule.class,
        injects = {
                DaggerService.class
        },
        library = true
)
public class ServiceModule {
    private final Service service;

    ServiceModule(Service service) {
        this.service = service;
    }

    @Provides
    @ForService
    Context provideServiceContext() {
        return service;
    }
}
