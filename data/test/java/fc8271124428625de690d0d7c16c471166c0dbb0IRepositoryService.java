package org.absolutegalaber.simpleoauth.shadow.service;

import org.absolutegalaber.simpleoauth.shadow.repository.IClientRepository;
import org.absolutegalaber.simpleoauth.shadow.repository.IPersistenNetworkTokenRepository;
import org.absolutegalaber.simpleoauth.shadow.repository.IShadowTokenRepository;

/**
 * @author Peter Schneider-Manzell
 */
public interface IRepositoryService {

    IShadowTokenRepository getShadowTokenRepository();

    IClientRepository getClientRepository();

    IPersistenNetworkTokenRepository getPersistenNetworkTokenRepository();


}
