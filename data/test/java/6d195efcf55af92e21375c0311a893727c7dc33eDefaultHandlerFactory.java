package com.larsgeorge.valta.hbase.handler;

import com.larsgeorge.valta.hbase.handler.accounting.AccountingHandler;
import com.larsgeorge.valta.hbase.handler.accounting.DefaultAccountingHandler;
import com.larsgeorge.valta.hbase.handler.authentication.AuthenticationHandler;
import com.larsgeorge.valta.hbase.handler.authentication.DefaultAuthenticationHandler;
import com.larsgeorge.valta.hbase.handler.authorizaton.AuthorizationHandler;
import com.larsgeorge.valta.hbase.handler.authorizaton.DefaultAuthorizationHandler;

/**
 * Implements the default handler factory.
 *
 * User: larsgeorge
 * Date: 3/18/12 12:42 PM
 */
public class DefaultHandlerFactory extends HandlerFactory {
  private AuthenticationHandler _authenticationHandler = null;
  private AuthorizationHandler _authorizationHandler = null;
  private AccountingHandler _accountingHandler = null;

  @Override
  public synchronized AuthenticationHandler getAuthenticationHandler() {
    if (_authenticationHandler == null)
     _authenticationHandler = new DefaultAuthenticationHandler(_conf);
    return _authenticationHandler;
  }

  @Override
  public AuthorizationHandler getAuthorizationHandler() {
    if (_authorizationHandler == null)
     _authorizationHandler = new DefaultAuthorizationHandler(_conf);
    return _authorizationHandler;
  }

  @Override
  public AccountingHandler getAccountingHandler() {
    if (_accountingHandler == null)
     _accountingHandler = new DefaultAccountingHandler(_conf);
    return _accountingHandler;
  }
}
