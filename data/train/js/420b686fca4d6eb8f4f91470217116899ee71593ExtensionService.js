/**
 * @author btilford
 * 8/20/12 9:44 PM
 * @version 1.0.0
 * @since
 * @namespace
 * @exports
 * @requires
 *
 * @description
 *
 *
 */
'use-strict';


define(
  'services/ExtensionService'
  ,[
    'options-module'

    ,'angularjs'
  ]
  ,function extensionServiceLoaded(module) {
    var Service = function ExtensionService() {
      var service = {}

      service.list = function list(callback) {
        chrome.management.getAll(callback)
      }



      return service
    }

    module.factory('ExtensionService', Service)
    return Service
  }

)