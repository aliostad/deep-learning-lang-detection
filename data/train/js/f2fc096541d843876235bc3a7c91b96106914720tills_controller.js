//= require "tills_audit_controller"
//= require "tills_overview_controller"
//= require "tills_admin_controller"

var TillsController = new JS.Class({
  
  initialize: function() {
    this.audit_controller = new TillsAuditController('div#audit');
    this.overview_controller = new TillsOverviewController('section#overview');
    this.admin_controller = new TillsAdminController('section#admin');
    this.section_controller = new SectionController('ul#tills_nav', [
      this.overview_controller,
      this.admin_controller
    ]);
    this.reset();
    
    this.audit_controller.addObserver(this.loadTills, this);
    this.overview_controller.addObserver(this.auditTill, this);
    this.admin_controller.addObserver(this.auditTill, this);
  },
  
  reset: function() {
    this.audit_controller.reset();
    this.overview_controller.reset();
    this.admin_controller.reset();
    this.section_controller.reset();
  },
  
  loadTills: function() {
    this.overview_controller.update();
    this.admin_controller.update();
  },
  
  auditTill: function(till) {
    this.audit_controller.update(till);
    this.audit_controller.reset();
    this.audit_controller.view.show();
  }
});