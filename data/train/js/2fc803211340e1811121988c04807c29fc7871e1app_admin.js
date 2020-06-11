/**
 * Created by yedaodao on 2015/5/23.
 */
define(
    [
        'lib',
        'instance/controllers/admin/instance.controller',
        'instance/controllers/admin/instance.detail.controller',
        'instance/directive/modal/controller/create.instance.controller',
        'instance/controllers/admin/alarm.controller',
        'instance/services/server.service',
        'instance/services/oam.service',
        'instance/services/instance.status.service',
        'instance/repository/server.repository',
        'instance/directive/select.time.directive',
        'instance/directive/modal/controller/delete.modal.controller',
        'instance/directive/modal/controller/migrate.modal.controller',
        'instance/directive/modal/controller/reboot.modal.controller',
        'instance/directive/modal/controller/stop.modal.controller',
        'instance/directive/modal/controller/resize.instance.controller',
        'instance/directive/modal/controller/create.snapshot.controller',
        'instance/directive/modal/controller/create.capture.controller',
        'instance/directive/modal/controller/change.password.controller'
    ],
    function (Lib, instanceController, instanceDetailController, createInstanceController, alarmController, serverService, OAMService, InstanceStatusService, serverRepository, chartDirective, deleteModalController, migrateModalController, rebootModalController, stopModalController, resizeInstanceController, createInstanceSnapShotController, createCaptureController, changePasswordController) {
        var ApplicationConfiguration = Lib.ApplicationConfiguration;
        return {
            start: function () {
                ApplicationConfiguration.registerModule('instance');
                instanceController();
                instanceDetailController();
                createInstanceController();
                alarmController();
                serverService();
                OAMService();
                InstanceStatusService();
                serverRepository();
                chartDirective();
                deleteModalController();
                migrateModalController();
                rebootModalController();
                stopModalController();
                resizeInstanceController();
                createInstanceSnapShotController();
                createCaptureController();
                changePasswordController();
            }
        }
    }
);