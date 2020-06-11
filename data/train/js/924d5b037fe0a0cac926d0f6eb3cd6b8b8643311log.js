// ==========================================================================
// Project:   Dispatch.Log
// Copyright: ©2011 My Company, Inc.
// ==========================================================================
/*globals Dispatch */

/** @class

  (Document your Model here)

  @extends SC.Record
  @version 0.1
*/
Dispatch.Log = SC.Record.extend(
/** @scope Dispatch.Log.prototype */ {

  // TODO: Add your own code here.
    parentIncident: SC.Record.toOne("Dispatch.Incident"),
    parentResource: SC.Record.toOne("Dispatch.Resource"),
    parentAssignment: SC.Record.toOne("Dispatch.Assignment"),
    
    changes: SC.Record.toMany("Dispatch.LogItem", {nested: true}),
    
    when: SC.Record.attr(SC.DateTime),
    who: SC.Record.attr(String)
}) ;
