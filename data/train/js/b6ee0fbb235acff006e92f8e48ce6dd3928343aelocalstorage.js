(function() {
  'use strict';

  /**
   * ローカルストレージへの操作をつかさどるサービス
   *
   * @class LocalstorageService
   * @constructor
   */
  function LocalstorageService(ConstantService) {

    console.log('localstorage');

    var storage = window.localStorage;
    var KEY = ConstantService.LOCAL_STORAGE_KEY;

    var localstorageService = {

      // ローカルストレージにTODOリストの保存
      save: function(list) {
        storage.setItem(KEY, JSON.stringify(list));
        return;
      },

      // ロカールストレージからTODOリストを取得
      get: function() {
        var list = JSON.parse(storage.getItem(KEY));
        if (!list) {
          list = [];
        }

        return list;
      }
    };
    return localstorageService;
  }

  angular.module('kusuhatalighttodo2.service.localstorage', [
    'kusuhatalighttodo2.service.localstorage',
    'kusuhatalighttodo2.service.constant'
  ]).factory('LocalstorageService', LocalstorageService);

  LocalstorageService.$inject = ['ConstantService'];
})();
