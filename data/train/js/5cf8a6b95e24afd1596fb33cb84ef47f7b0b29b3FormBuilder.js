Template.peopleForm.helpers({
  showCreate:function(){
    return Session.get("showCreate");
  },
  showUpdate:function(){
    return Session.get("showUpdate");
  },
  getPerson:function(){
    var person = People.findOne();
    return person && person._id;
  }
});
Session.set("showCreate", true);
Template.peopleForm.events({
  'click .fbShow-create': function(event, template) {
    Session.set("showCreate", true);
    Session.set("showUpdate", false);
  },
  'click .fbShow-update': function(event, template) {
    Session.set("showCreate", false);
    Session.set("showUpdate", true);
  },
  'click .fbShow-read': function(event, template) {
    Session.set("showCreate", false);
    Session.set("showUpdate", false);
  }
});