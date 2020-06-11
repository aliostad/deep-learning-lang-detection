package controller;

import model.User;
import service.ServiceException;
import service.SessionService;
import service.user.AuthenticationService;

/**
 * Created by LacraDanciu on 25-Mar-17.
 */
public class LoginController {
    private final AuthenticationService authenticationService;
    private final SessionService sessionService;

    public LoginController(AuthenticationService authenticationService, SessionService sessionService) {
        this.authenticationService = authenticationService;
        this.sessionService = sessionService;
    }

    public void authenticate(String username, String password) throws ServiceException {
        User currentUser = authenticationService.login(username, password);
        sessionService.setAuthenticatedUser(currentUser);
    }

    public void register(String username, String password) throws ServiceException {
        authenticationService.register(username, password);
    }
}