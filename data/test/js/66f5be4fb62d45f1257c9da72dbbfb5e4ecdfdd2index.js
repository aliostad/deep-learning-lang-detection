
define(["App"
  ,"./dashboard"
    ,"./projects"
   ,"./projectModal"
    ,"./employee"
    ,"./employeeModal"
    ,"./Task"
    ,"./taskModal"
 ],function(app,dashboard,projects,projectModal,employee,employeeModal,task,taskModal){
    return function(app) {
        app.controller("dashboardController", dashboard);
        app.controller("projectController", projects);
        app.controller("projectModalController",projectModal);
        app.controller("employeeController",employee);
        app.controller("employeeModalController",employeeModal);
        app.controller("taskController",task);
        app.controller("taskModalController",taskModal);
    }
});