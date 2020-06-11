HappeningsProjectEmberClient.HappeningController = Ember.ArrayController.extend({
  needs: ["application"]
  // navStructure: {
  //   city: "Madrid",
  //   range: "today",
  //   category: "music"
  // },
  // // currentCategory: "music",
  // // currentRange: "today",
  // // currentCity: "Madrid",

  // rangeNavItems: function() {
  //   return HappeningsProjectEmberClient.NavItem.getRangeNavItems(this.get('navStructure.range'), this.get('navStructure.category'));
  // }.property('navStructure.category', 'navStructure.range'),

  // cityNavItems: function() {
  //   return HappeningsProjectEmberClient.NavItem.getCityNavItems(this.get('navStructure.city'));
  // }.property('navStructure.city'),

  // categoryNavItems: function() {
  //   return HappeningsProjectEmberClient.NavItem.getCategoryNavItems(this.get('navStructure.category'));
  // }.property('navStructure.category')

});

