package com.ishabaev.sonnik.repository;


import android.support.annotation.NonNull;

public class RepositoryProvider {

    private static SonnikRepository sRepository;

    private RepositoryProvider() {
    }

    @NonNull
    public static SonnikRepository provideRepository() {
        if (sRepository == null) {
            sRepository = new DefaultSonnikRepository();
        }
        return sRepository;
    }

    public static void setRepository(@NonNull SonnikRepository provider) {
        sRepository = provider;
    }

}
