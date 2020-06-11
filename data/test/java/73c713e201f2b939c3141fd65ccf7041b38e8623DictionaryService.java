package service;

import entity.Comic;
import entity.Dictionary;
import repository.DictionaryRepository;
import repository.SmartRepository;

import javax.ejb.Stateless;
import javax.inject.Inject;
import javax.inject.Named;

/**
 * Created by asari on 2015/05/15.
 */
@Stateless
public class DictionaryService extends AbstractService<Dictionary> {

    @Inject
    private DictionaryRepository repository;

    @Override
    public SmartRepository<Dictionary> getRepository() {
        return repository;
    }
}
