(function(angular) {
  'use strict';

  angular.module('sauWebApp').factory('regionToggles', function() {

    // default region detail toggles to be extended by region-specific overrides below
    var defaultToggles = {
      showMiniMap: true,
      showMaricultureMiniMap: false,
      showFAOAndLegend: true,
      showFAOs: false,
      showGlobalSubRegion: false,
      showLegend: true,
      showDisclaimer: true,
      showMaricultureLegend: false,
      showFAOEEZLinks: true,
      showMultiRegionList: false,
      showMetrics: true
    };

    var toggles = {
      eez: angular.extend({}, defaultToggles, {
        showFAOs: true
      }),

      lme: angular.extend({}, defaultToggles, {
        showDisclaimer: false,
        showFAOEEZLinks: false
      }),

      highseas: angular.extend({}, defaultToggles, {
        showFAOEEZLinks: false
      }),

      rfmo: angular.extend({}, defaultToggles, {
        showFAOAndLegend: false
      }),

      global: angular.extend({}, defaultToggles, {
        showMiniMap: false,
        showGlobalSubRegion: true
      }),

      mariculture: angular.extend({}, defaultToggles, {
        showMiniMap: false,
        showMaricultureMiniMap: true,
        showLegend: false,
        showDisclaimer: false,
        showMaricultureLegend: true,
        showFAOEEZLinks: false,
        showMetrics: false
      }),

      multi: angular.extend({}, defaultToggles, {
        showMiniMap: false,
        showFAOAndLegend: false,
        showMultiRegionList: true,
        showMetrics: false
      }),

      'fishing-entity': angular.extend({}, defaultToggles, {
        showLegend: false
      }),

      fao: angular.extend({}, defaultToggles, {
        showDisclaimer: false
      }),

      default: defaultToggles
    };

    function getToggles(region) {
      return toggles.hasOwnProperty(region) ? toggles[region] : toggles.default;
    }

    return { getToggles: getToggles };
  });
})(angular);
