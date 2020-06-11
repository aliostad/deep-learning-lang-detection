Template.find.created = function() {
  Session.set('display_service', "supNo2QhnirQ9Zqa9") //Support Groups
}

Template.find.helpers({
  locations: function() {
    var service_id = Session.get('display_service');
    var county = Session.get('county');
    if (!service_id || !county) {
      return []
    }
    var service = Services.findOne({_id:service_id});
    if (service) {
      return Locations.find({service_area:county._id,
                             sub_service_ids:{$in:service.children}});
    } else {
      return [];
    }
  },
  parent_name: function() {
    var service_id = Session.get('display_service');
    var service = Services.findOne({_id:service_id});
    if (!service) {
      return 'Select a Category'
    }
    return service.name;
  }
});

Template.parent_button.events({
  'click .parent_button': function(e, tmpl) {
    Session.set('display_service', this._id);
  },
});
