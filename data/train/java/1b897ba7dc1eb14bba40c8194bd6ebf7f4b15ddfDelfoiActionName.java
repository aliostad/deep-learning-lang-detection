package fi.metatavu.edelphi;

public enum DelfoiActionName {
  // Delfoi scoped actions
  CREATE_PANEL,                           // the ability to create new panels
  MANAGE_SYSTEM_SETTINGS,                 // the ability to modify system settings, e.g. role access to these actions
  MANAGE_USER_PROFILE,                    // the ability to manage (own) user profile information
  MANAGE_DELFOI,                          // Manage Delfoi
  MANAGE_DELFOI_MATERIALS,                // Delfoi management, help texts etc
  MANAGE_BULLETINS,                       // the ability to manage bulletins
  MANAGE_SUBSCRIPTION_LEVELS,             // the ability to manage subscription levels
  MANAGE_PLANS,                           // the ability to manage plans
    // Panel scoped actions
  ACCESS_PANEL,                           // the ability to view a panel and its materials, i.e. documents, images, and queries
  ACCESS_PANEL_REPORTS,                   // the ability to view reports published in the panel
  ACCESS_QUERY_COMMENTS,                  // the ability to view query comments
  CREATE_QUERY_COMMENTS,                  // the ability to comment queries
  CREATE_QUERY_RESPONSE,                  // the ability to respond to queries
  MANAGE_PANEL,                           // the ability to manage panel settings, i.e. access its administrative dashboard
  MANAGE_PANEL_INVITATIONS,               // the ability to manage panel invitations
  MANAGE_PANEL_MATERIALS,                 // the ability to manage panel materials, i.e. documents, images, and queries 
  MANAGE_PANEL_SYSTEM_SETTINGS,           // the ability to modify panel system settings, e.g. role access to these actions
  MANAGE_QUERY_COMMENTS,                  // the ability to moderate query comments
  MANAGE_PANEL_USERS,                     // the ability to manage panel members
  MANAGE_PANEL_BULLETINS,                 // the ability to manage panel bulletins
  CLEAR_QUERY_DATA,                       // the ability to clear reply data from queries
  MANAGE_QUERY_RESULTS                    // the ability to view query results
}
