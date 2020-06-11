function TranslationService($translate, localStorageService, IdentityService) {
  return {
    useLanguage: function(language) {
      $translate.use(language);
      localStorageService.set('language', language);
      IdentityService.language = language;
      IdentityService.shortLanguage = language.substring(0, 2);
    },
    getCurrentLanguage: function() {
      return $translate.use();
    }
  };
}

TranslationService.$inject = ['$translate', 'localStorageService', 'IdentityService'];
angular.module('app').factory('TranslationService', TranslationService);
