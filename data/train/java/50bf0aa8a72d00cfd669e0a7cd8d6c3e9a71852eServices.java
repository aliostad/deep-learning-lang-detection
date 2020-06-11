/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.smartitengineering.user.service;

import com.smartitengineering.util.bean.BeanFactoryRegistrar;
import com.smartitengineering.util.bean.annotations.Aggregator;
import com.smartitengineering.util.bean.annotations.InjectableField;

/**
 *
 * @author russel
 */
@Aggregator(contextName = "com.smartitengineering.user.service")
public class Services {

  @InjectableField
  private OrganizationService organizationService;
  @InjectableField
  private UserService userService;
  @InjectableField
  private PrivilegeService privilegeService;
  @InjectableField
  private RoleService roleService;
  @InjectableField
  private SecuredObjectService securedObjectService;
  @InjectableField
  private UserGroupService userGroupService;
  @InjectableField
  private UserPersonService userPersonService;
  @InjectableField
  private AuthorizationService authorizationService;
  @InjectableField
  private PersonService personService;

  private Services() {
  }

  public PersonService getPersonService() {
    return personService;
  }

  public void setPersonService(PersonService personService) {
    this.personService = personService;
  }

  public AuthorizationService getAuthorizationService() {
    return authorizationService;
  }

  public void setAuthorizationService(AuthorizationService authorizationService) {
    this.authorizationService = authorizationService;
  }

  public OrganizationService getOrganizationService() {
    return organizationService;
  }

  public UserService getUserService() {
    return userService;
  }

  public PrivilegeService getPrivilegeService() {
    return privilegeService;
  }

  public RoleService getRoleService() {
    return roleService;
  }

  public SecuredObjectService getSecuredObjectService() {
    return securedObjectService;
  }

  public void setSecuredObjectService(SecuredObjectService securedObjectService) {
    this.securedObjectService = securedObjectService;
  }

  public UserGroupService getUserGroupService() {
    return userGroupService;
  }

  public void setUserGroupService(UserGroupService userGroupService) {
    this.userGroupService = userGroupService;
  }

  public UserPersonService getUserPersonService() {
    return userPersonService;
  }

  public void setUserPersonService(UserPersonService userPersonService) {
    this.userPersonService = userPersonService;
  }
  private static Services services;

  public static Services getInstance() {
    if (services == null) {
      services = new Services();
      BeanFactoryRegistrar.aggregate(services);
    }
    return services;
  }
}
