define(['underscore'], function(_) {

    var controllerPathMap = {
            desktop: {
                'desktopController' : 'controllers/globalController',
                'loginController' : 'views/common/login/LoginController',
                'warehouseController' : 'views/warehouse_old/controller/WarehouseController',
                'warehouseDocumentController' : 'views/warehouse_old/controller/WarehouseDocumentController',
                'warehouseSetupController' : 'views/warehouse/setup/controller/WarehouseSetupController',
                'assignDCController' : 'views/deliverycontrol/assign/controller/AssignDCController',
                'myOrderOverviewController' : 'views/deliverycontrol/myorderoverview/controller/MyOrderOverviewController', 
                'orderOverviewDetailsController' : 'views/deliverycontrol/myorderoverview/details/controller/OrderOverviewDetailsController',
                'unassignedRequestController' : 'views/procurement/unassigned/controller/UnassignedRequestController',
                'procurementOverviewController' : 'views/procurement/overview/controller/ProcurementOverviewController',
                'procurementDetailController' : 'views/procurement/detail/controller/ProcurementDetailController',
                'modifyDetailsController' : 'views/procurement/overview/modifydetail/controller/ModifyDetailsController',
                'changeDetailsController' : 'views/procurement/changedetails/controller/ChangeDetailsController',
                'materialRequestOverviewController' : 'views/materialrequest/overview/controller/OverviewController',
                'materialRequestDetailController' : 'views/materialrequest/details/controller/DetailsController',
                'testingUtilityController' : 'views/testingutility/controller/TestingUtilityController',
                'dataMigrationController' : 'views/testingutility/controller/DataMigrationController',
                'startpageController' : 'views/common/startpage/StartpageController',
                'materialLineController' : 'views/material/overview/controller/MaterialLineController',
                'materialRequestsController' : 'views/material/requests/controller/MaterialRequestsController',
                'materialDetailsController' : 'views/material/details/controller/MaterialDetailsController',
                'warehouseToReceiveController': 'views/warehouse/receive/controller/ToReceiveController',
                'warehouseNotReceivedController': 'views/warehouse/receive/controller/NotReceivedController',
                'warehouseReceivedController': 'views/warehouse/receive/controller/ReceivedController',
                'warehouseReceiveDetailsController': 'views/warehouse/receive/details/controller/WarehouseReceiveDetailsController',
                'warehouseStoreController': 'views/warehouse/store/controller/StoreController',
                'warehousePickController' :  'views/warehouse/pick/controller/PickController',
                'warehouseShipController' :  'views/warehouse/pick/controller/ShipController',
                'warehouseInventoryController' :  'views/warehouse/inventory/controller/InventoryController',
                'warehouseQISettingsController' : 'views/warehouse/qisettings/controller/QISettingsController',
                'qualityInspectionOverviewController': 'views/warehouse/qualityinspection/overview/controller/QualityInspectionOverviewController',
                'qualityInspectionDetailsController' : 'views/warehouse/qualityinspection/details/controller/QualityInspectionDetailsController',
                'adminTeamController' : 'views/admin/controller/AdminTeamController',
                'reportsController' : 'views/reports/controller/ReportsController',
                'applicationStatusController' : 'views/applicationstatus/controller/ApplicationStatusController'
            },
            mobile: {
                'mobileController' : 'controllers/globalController.mobile',
                'loginController' : 'views/common/login/LoginController',
                'mobileStartpageController' : 'views/mobile/startpage/StartpageController',
                'receiveController' : 'views/mobile/warehouse/controller/ReceiveController',
                'storeController' : 'views/mobile/warehouse/controller/StoreController',
                'pickController' : 'views/mobile/warehouse/controller/PickController',
                'moveController' : 'views/mobile/warehouse/controller/MoveController'
            }
    };
    
    controllerPathMap = _.extend(controllerPathMap.desktop, controllerPathMap.mobile);
    
    // Define Controller Manager to manage controller states
    var ControllerManager = function() {
        //Controllers hold all references to existing controllers
        this.controllers = this.controllers || {};
    };
    
    _.extend(ControllerManager.prototype, {
        //ControllerManager.getController always returns existing controller.
        // it executes callback function to return the controller
        getController : function(name, callback) {            
            if(!name || !callback) return;
            
            var that = this;
            var args = Array.prototype.slice.call(arguments, 2); 
            var controller = this.controllers[name];  
            
            if (typeof controller === 'undefined') {
                
                require([controllerPathMap[name]], function(TheController) {
                    controller = new TheController();
                    that.controllers[name] = controller;
                    args.push(controller);                    
                    var returnValue = callback.apply(callback, args);
                    that.closeUnusedControllers(name);
                    return returnValue;
                });
                
            } else {                
                args.push(controller);                
                var returnValue = callback.apply(callback, args);
                this.closeUnusedControllers(name);
                return returnValue;
            }
        },
        
        /**
         * First find the unused controllers and then close and remove them.
         */
        closeUnusedControllers: function(inuseControllerName) {
            var unusedControllers = this.getUnusedControllers(inuseControllerName);
            this.colseControllers(unusedControllers);
        },
        
        /**
         * @return an array of controller names which are existed in this.controllers 
         * except the controller namr which is passed  to this method.
         */
        getUnusedControllers: function(inuseControllerName) {
            var unusedControllers = [];
            for(var controller in this.controllers) {
                if(inuseControllerName !== controller)
                    unusedControllers.push(controller);
            }           
            return unusedControllers;
        },
        
        /**
         * controllers parameter is an array which contains name of controllers as string 
         * This method close and remove all controllers which is passed to it
         * except 'desktopController' and 'mobileController' which are global controllers.
         */
        colseControllers: function(controllers) {
            _.each(controllers, function(controllerName) {
                if(controllerName !== 'desktopController' && controllerName !== 'mobileController') {                    
                    try {
                        this.controllers[controllerName].destroy();
                        this.controllers[controllerName] = null;
                        delete this.controllers[controllerName];
                    } catch(e) {
                        console.log(e);
                    }
                }
            }, this);
        }
    });

    var instance;
    var getInstance = function() {
        if (!instance) {
            instance = new ControllerManager();
        }
        return instance;
    };

    return {
        getInstance : getInstance
    };
});
