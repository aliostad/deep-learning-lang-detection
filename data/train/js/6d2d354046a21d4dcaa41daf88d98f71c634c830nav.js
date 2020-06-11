App.View.Nav = Backbone.View.extend({
  events: {
    'click .dropdown-nav label': 'toggleDropdownNav',
    'click .dropdown-nav li': 'hideDropdownNav',
  },

  tagName: 'div',

  className: 'app-view-nav',

  initialize: function() {
    this.render();
  },

  render: function() {
    $(this.el).html(JST['templates/views/nav']()); 
    $(this.el).find('.dropdown-nav ul').hide();
  },

  toggleDropdownNav: function() {
    $(this.el).find('.dropdown-nav ul').toggle();
  },

  hideDropdownNav: function() {
    $(this.el).find('.dropdown-nav ul').hide();
  }
});
