package br.com.thindroid;

import br.com.thindroid.commons.database.DefaultRepository;

/**
 * Created by Carlos on 24/03/2016.
 */
@br.com.thindroid.annotations.Repository(value = "sample-repository.db", managedClassList = {DaoTest.class})
public class Repository extends DefaultRepository {

    private static final String REPOSITORY_NAME = "sample-repository.db";
    private static final int VERSION = 1;

    public Repository() {
        super(Application.getContext(), REPOSITORY_NAME, null, VERSION);
    }
}
