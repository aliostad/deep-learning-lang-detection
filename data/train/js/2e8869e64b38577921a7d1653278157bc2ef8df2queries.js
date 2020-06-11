sc_require('models/incident');
sc_require('models/resource');
sc_require('models/assignment');

Dispatch.INCIDENTS_ACTIVE = SC.Query.local(Dispatch.Incident, {
  conditions: "disposition != 'Closed'"
});

Dispatch.INCIDENTS_ALL = SC.Query.local(Dispatch.Incident, {
  
});

Dispatch.RESOURCES_ALL = SC.Query.local(Dispatch.Resource, {
  
});

Dispatch.RESOURCES_ACTIVE = SC.Query.local(Dispatch.Resource, {
  conditions: "currentStatus != 'Off Duty'"
});

Dispatch.ASSIGNMENTS_ALL = SC.Query.local(Dispatch.Assignment, {
  
});