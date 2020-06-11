//= require "overview_controller"
//= require "admin_controller"

var TimeclockController = new JS.Class({
  
  initialize: function() {
    this.overview_controller = new OverviewController('section#overview');
    this.admin_controller = new AdminController('section#admin');
    this.section_controller = new SectionController('ul#timeclock_nav', [
      this.overview_controller,
      this.admin_controller
    ]);
    this.reset();
    
    this.overview_controller.updateClock();
    this.overview_controller.updateCanvas();
    this.overview_controller.updateCharts();
  },
  
  reset: function() {
    this.overview_controller.reset();
    this.admin_controller.reset();
    this.section_controller.reset();
  }
});