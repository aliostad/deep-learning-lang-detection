// ==========================================================================
// Project:   Dispatch
// Copyright: ©2010 My Company, Inc.
// ==========================================================================
/*globals Dispatch */

// This is the function that will start your app running.  The default
// implementation will load any fixtures you have created then instantiate
// your controllers and awake the elements on your page.
//
// As you develop your application you will probably want to override this.
// See comments for some pointers on what to do next.
//
Dispatch.main = function main() {

  // Step 1: Instantiate Your Views
  // The default code here will make the mainPane for your application visible
  // on screen.  If you app gets any level of complexity, you will probably 
  // create multiple pages and panes.  
  Dispatch.getPath('mainPage.mainPane').append() ;

  // Step 2. Set the content property on your primary controller.
  // This will make your app come alive!

  // TODO: Set the content property on your primary controller
  // ex: Dispatch.contactsController.set('content',Dispatch.contacts);
  Dispatch.resourceArrayController.set('content', Dispatch.store.find(Dispatch.RESOURCES_ALL));
  Dispatch.incidentArrayController.set('content', Dispatch.store.find(Dispatch.INCIDENTS_ALL));
  Dispatch.store.find(Dispatch.ASSIGNMENTS_ALL);
  //Dispatch.assignmentArrayController.set('content', Dispatch.store.find("Dispatch.Assignment"));
  
  Dispatch.notificationClient = Dispatch.CouchNotificationClient.create({dbName: 'dispatch-dev'});
  
  
  Dispatch.generalMasterViewController.set('content', Dispatch.GeneralMasterView.tree);
} ;

function main() { Dispatch.main(); }
