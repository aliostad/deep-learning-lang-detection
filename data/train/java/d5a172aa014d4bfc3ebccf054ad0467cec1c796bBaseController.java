package controllers;

import repositories.IAuthenticationRepository;
import repositories.IPersonRepository;

/**
 * Created by dominik.kotecki on 04-01-2016.
 */
public abstract class BaseController {
    private final IAuthenticationRepository authenticationRepository;

    public BaseController(IAuthenticationRepository authenticationRepository) {
        this.authenticationRepository = authenticationRepository;
    }

    public IAuthenticationRepository getAuthenticationRepository() {
        return authenticationRepository;
    }
}
