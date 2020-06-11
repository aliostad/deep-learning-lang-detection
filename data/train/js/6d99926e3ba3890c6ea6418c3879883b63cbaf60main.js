'use strict';

/**
 * @ngdoc function
 * @name angularSandboxApp.controller:MainCtrl
 * @description
 * # MainCtrl
 * Controller of the angularSandboxApp
 */
angular.module('angularSandboxApp')
  .controller('MainCtrl', function () {
    this.showButtons = false;
    this.showCheckboxes = false;
    this.showColors = false;

    this.toggleButtons = function(){
      this.showButtons = !this.showButtons;
      this.showCheckboxes = false;
      this.showColors = false;
    }

    this.toggleCheckboxes = function(){
      this.showButtons = false;
      this.showColors = false;
      this.showCheckboxes = !this.showCheckboxes;
    }

    this.toggleColors = function(){
      this.showButtons = false;
      this.showCheckboxes = false;
      this.showColors = !this.showColors;
    }
  });
