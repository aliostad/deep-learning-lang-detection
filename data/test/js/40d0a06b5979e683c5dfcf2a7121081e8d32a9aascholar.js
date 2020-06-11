Ext.application({
	requires : [ 'Ext.container.Viewport'],
    name: 'scholar',
    autoCreateViewport: true,
    
    /*launch: function() {
        Ext.create('Ext.container.Viewport', {
            layout: 'fit',
            items: [
                {
                    title: 'Scholar',
                    html : 'Hello! Welcome to Scholar.'
                }
            ]
        });
    }*/
    
    controllers: [
                  'Scholar',
                  'scholar.controller.administration.DashboardController',
                  'scholar.controller.administration.settings.batch.Controller',
                  'scholar.controller.administration.settings.department.Controller',
                  'scholar.controller.administration.settings.course.Controller',
                  'scholar.controller.administration.settings.general.Controller',
                  'scholar.controller.administration.settings.subject.Controller',                  
                  'scholar.controller.administration.inventory.elec.Controller',
                  'scholar.controller.administration.inventory.infra.Controller',
                  'scholar.controller.administration.inventory.perishable.Controller',                  
                  'scholar.controller.administration.user.roles.Controller',
                  'scholar.controller.administration.user.Controller',
                  
                  'scholar.controller.finance.fees.Controller',
                  'scholar.controller.finance.payroll.Controller',
                  'scholar.controller.finance.settings.general.Controller',
                  
                  'scholar.controller.library.lookup.Controller',
                  
                  'scholar.controller.staff.examination.schedule.Controller',
                  'scholar.controller.staff.examination.settings.Controller',                  
                  'scholar.controller.staff.attendance.Controller',
                  'scholar.controller.staff.event.Controller',
                  'scholar.controller.staff.leave.settings.Controller',
                  'scholar.controller.staff.leave.report.Controller',
                  'scholar.controller.staff.lookup.Controller',
                  'scholar.controller.staff.timetable.Controller',
                  
                  'student.admission.Controller',
                  'scholar.controller.student.attendance.Controller',
                  'scholar.controller.student.lookup.Controller',
                  'scholar.controller.student.performance.Controller',
                  'scholar.controller.student.Controller',
                  
                  'scholar.controller.transport.route.Controller',
                  'scholar.controller.transport.vehicle.Controller',
                  'scholar.controller.transport.Controller'
              ],
});