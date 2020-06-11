'use strict';

var fs = require('fs');

module.exports = angular.module('app.patterns', [
  'ui.router',
  require('../../../_shared/angular/resources/spaces/spaces').name
])

.config(
  function($stateProvider) {
    $stateProvider
      .state('app.pattern', {
        url: '/patterns',
        views: {
          '@': {
            controller: 'PatternController',
            template: fs.readFileSync(__dirname + '/templates/_patterns.html')
          }
        }
      })
      .state('app.pattern.styleguide', {
        url: '/styleguide',
          controller: 'PatternController',
          controllerAs: 'styleguide',
          template: fs.readFileSync(__dirname + '/templates/styleguide.html')
      })
      .state('app.pattern.accordion', {
        url: '/accordion',
          controller: 'DemoAccordionController',
          controllerAs: 'accordionDemo',
          template: fs.readFileSync(__dirname + '/templates/accordion-demo.html')
      })
      .state('app.pattern.alert', {
        url: '/alerts',
          controller: 'DemoAlertController',
          controllerAs: 'alertDemo',
          template: fs.readFileSync(__dirname + '/templates/alert-demo.html')
      })
      .state('app.pattern.buttons', {
        url: '/buttons',
          controller: 'DemoButtonsController',
          controllerAs: 'buttonDemo',
          template: fs.readFileSync(__dirname + '/templates/buttons-demo.html')
      })
      .state('app.pattern.carousel', {
        url: '/carousel',
          controller: 'DemoCarouselController',
          controllerAs: 'carouselDemo',
          template: fs.readFileSync(__dirname + '/templates/carousel-demo.html')
      })
      .state('app.pattern.collapse', {
        url: '/collapse',
          controller: 'DemoCollapseController',
          controllerAs: 'collapseDemo',
          template: fs.readFileSync(__dirname + '/templates/collapse-demo.html')
      })
      .state('app.pattern.datepicker', {
        url: '/datepicker',
          controller: 'DemoDatepickerController',
          controllerAs: 'datepickerDemo',
          template: fs.readFileSync(__dirname + '/templates/datepicker-demo.html')
      })
      .state('app.pattern.dropdown', {
        url: '/dropdown',
          controller: 'DemoDropdownController',
          controllerAs: 'dropdownDemo',
          template: fs.readFileSync(__dirname + '/templates/dropdown-demo.html')
      })
      .state('app.pattern.input', {
        url: '/input',
          controller: 'DemoInputController',
          controllerAs: 'inputDemo',
          template: fs.readFileSync(__dirname + '/templates/input-demo.html')
      })
      .state('app.pattern.modal', {
        url: '/modal',
          controller: 'DemoModalController',
          controllerAs: 'modalDemo',
          template: fs.readFileSync(__dirname + '/templates/modal-demo.html')
      })
      .state('app.pattern.pagination', {
        url: '/pagination',
          controller: 'DemoPaginationController',
          controllerAs: 'paginationDemo',
          template: fs.readFileSync(__dirname + '/templates/pagination-demo.html')
      })
      .state('app.pattern.popover', {
        url: '/popover',
          controller: 'DemoPopoverController',
          controllerAs: 'popoverDemo',
          template: fs.readFileSync(__dirname + '/templates/popover-demo.html')
      })
      .state('app.pattern.progressbar', {
        url: '/progressbar',
          controller: 'DemoProgressbarController',
          controllerAs: 'progressbarDemo',
          template: fs.readFileSync(__dirname + '/templates/progressbar-demo.html')
      })
      .state('app.pattern.rating', {
        url: '/rating',
          controller: 'DemoRatingController',
          controllerAs: 'ratingDemo',
          template: fs.readFileSync(__dirname + '/templates/rating-demo.html')
      })
      .state('app.pattern.tabs', {
        url: '/tabs',
          controller: 'DemoTabsController',
          controllerAs: 'tabsDemo',
          template: fs.readFileSync(__dirname + '/templates/tabs-demo.html')
      })
      .state('app.pattern.timepicker', {
        url: '/timepicker',
          controller: 'DemoTimepickerController',
          controllerAs: 'timepickerDemo',
          template: fs.readFileSync(__dirname + '/templates/timepicker-demo.html')
      })
      .state('app.pattern.tooltip', {
        url: '/tooltip',
          controller: 'DemoTooltipController',
          controllerAs: 'tooltipDemo',
          template: fs.readFileSync(__dirname + '/templates/tooltip-demo.html')
      })
      .state('app.pattern.typeahead', {
        url: '/typeahead',
          controller: 'DemoTypeaheadController',
          controllerAs: 'typeaheadDemo',
          template: fs.readFileSync(__dirname + '/templates/typeahead-demo.html')
      });
  }
)

.controller('PatternController', require('./controllers/_pattern_controller'))

.controller('DemoAccordionController', require('./controllers/accordion_controller'))
.controller('DemoAlertController', require('./controllers/alert_controller'))
.controller('DemoButtonsController', require('./controllers/buttons_controller'))
.controller('DemoCarouselController', require('./controllers/carousel_controller'))
.controller('DemoCollapseController', require('./controllers/collapse_controller'))
.controller('DemoDatepickerController', require('./controllers/datepicker_controller'))
.controller('DemoDropdownController', require('./controllers/dropdown_controller'))
.controller('DemoInputController', require('./controllers/input_controller'))
.controller('DemoModalController', require('./controllers/modal_controller'))
.controller('ModalInstanceController', require('./controllers/modal_instance_controller'))
.controller('DemoPaginationController', require('./controllers/pagination_controller'))
.controller('DemoPopoverController', require('./controllers/popover_controller'))
.controller('DemoProgressbarController', require('./controllers/progressbar_controller'))
.controller('DemoRatingController', require('./controllers/rating_controller'))
.controller('DemoTabsController', require('./controllers/tabs_controller'))
.controller('DemoTimepickerController', require('./controllers/timepicker_controller'))
.controller('DemoTooltipController', require('./controllers/tooltip_controller'))
.controller('DemoTypeaheadController', require('./controllers/typeahead_controller'))
// .controller('DemoUISelectController', require('./controllers/ui_select_controller'))

;
