package com.globant.repository.RepositoryViews;

import android.os.Bundle;
import android.os.PersistableBundle;
import android.support.v7.app.AppCompatActivity;

import com.globant.repository.Repository;
import com.globant.repository.RepositoryListener;

/**
 * Created by efren.campillo on 24/02/16.
 */
public abstract class RepositoryActivity<TM, TI> extends AppCompatActivity {

    private RepositoryListener<TM> repositoryListener;
    private Repository<TM, TI> repository;

    @Override
    public void onCreate(Bundle savedInstanceState, PersistableBundle persistentState) {
        super.onCreate(savedInstanceState, persistentState);
        repository = provideRepository();
        repositoryListener = provideRepositoryListener();

    }

    public abstract Repository<TM, TI> provideRepository();

    public abstract RepositoryListener<TM> provideRepositoryListener();

    @Override
    protected void onResume() {
        super.onResume();
        repository.registerListener(repositoryListener);
        repository.resumePendingEvents();
    }

    @Override
    protected void onPause() {
        super.onPause();
        repository.unregisterListener(repositoryListener);
    }
}
