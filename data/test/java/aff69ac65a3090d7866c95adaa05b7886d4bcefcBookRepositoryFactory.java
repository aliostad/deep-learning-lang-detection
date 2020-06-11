package com.makenv.sheets.repository;

import com.makenv.sheets.repository.impl.MiRepository;

/**
 * Created by alei on 2015/1/27.
 */
public class BookRepositoryFactory {
    private static BookRepositoryFactory instance;
    private static BookRepository repository;

    public static BookRepositoryFactory getInstance() {
        if (instance == null) {
            synchronized (BookRepositoryFactory.class) {
                //TODO read configuration
                if (instance == null) {
                    instance = new BookRepositoryFactory();
                }
            }
        }
        return instance;
    }

    public BookRepository getRepository() {
        if (repository == null) {
            synchronized (BookRepositoryFactory.class) {
                if (repository == null) {
                    repository = new MiRepository();
                }
            }
        }
        return repository;
    }
}
