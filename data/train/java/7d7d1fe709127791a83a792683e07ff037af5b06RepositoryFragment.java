package com.globant.repository.RepositoryViews;

import android.app.Fragment;
import android.os.Bundle;

import com.globant.repository.Repository;
import com.globant.repository.RepositoryListener;

/**
 * Created by efren.campillo on 24/02/16.
 */
public abstract class RepositoryFragment<TM, TI> extends Fragment {

    private RepositoryListener<TM> repositoryListener;
    private Repository<TM, TI> repository;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        repository = provideRepository();
        repositoryListener = provideRepositoryListener();

    }

    public abstract Repository<TM, TI> provideRepository();

    public abstract RepositoryListener<TM> provideRepositoryListener();

    @Override
    public void onResume() {
        super.onResume();
        repository.registerListener(repositoryListener);
        repository.resumePendingEvents();
    }

    @Override
    public void onPause() {
        super.onPause();
        repository.unregisterListener(repositoryListener);
    }

}
