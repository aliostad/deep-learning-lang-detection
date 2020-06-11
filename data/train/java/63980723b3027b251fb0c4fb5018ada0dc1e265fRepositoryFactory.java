package com.lunaticedit.legendofwaffles.factories;

import com.lunaticedit.legendofwaffles.contracts.Repository;
import com.lunaticedit.legendofwaffles.helpers.Constants;
import com.lunaticedit.legendofwaffles.implementations.repository.LiveRepository;

public final class RepositoryFactory {
    private static Repository _liveRepository;

    private Repository getRepository() throws UnsupportedOperationException {
        switch (Constants.RepositoryType) {
            case Test: throw new UnsupportedOperationException("The Test repository has not been implemented!");
            case Live: if (_liveRepository == null) { _liveRepository = new LiveRepository(); } return _liveRepository;
        }  throw new UnsupportedOperationException("Unknown repository type supplied!");
    }
    public Repository generate() throws UnsupportedOperationException
    { return getRepository(); }
}
