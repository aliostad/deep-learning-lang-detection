package org.exoplatform.wiki.jpa.migration.mock;

import org.exoplatform.container.component.ComponentPlugin;
import org.exoplatform.services.organization.*;

/**
 *
 */
public class MockOrganizationService implements OrganizationService {

  private UserHandler userHandler = new MockUserHandler();
  private GroupHandler groupHandler = new MockGroupHandler();

  @Override
  public UserHandler getUserHandler() {
    return userHandler;
  }

  @Override
  public UserProfileHandler getUserProfileHandler() {
    return null;
  }

  @Override
  public GroupHandler getGroupHandler() {
    return groupHandler;
  }

  @Override
  public MembershipTypeHandler getMembershipTypeHandler() {
    return null;
  }

  @Override
  public MembershipHandler getMembershipHandler() {
    return null;
  }

  @Override
  public void addListenerPlugin(ComponentPlugin componentPlugin) throws Exception {

  }
}
