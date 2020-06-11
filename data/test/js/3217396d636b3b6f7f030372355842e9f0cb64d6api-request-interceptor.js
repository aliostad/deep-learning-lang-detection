/**
  * @ngdoc service
  * @name apiRequestInterceptor
  * @description 
  * Interceptor for `$http` service, replaces all request urls prefixed `/api`
  * with an api base path, `icrApiBasePath` constant.
  *
 */

export function apiRequestInterceptor(icrApiBasePath) {
  
  var apiBaseRegex = /^\/api/

  return {
    request: function(config) {
      // if the request url starts with api, then prepend the base api path onto the url
      if(apiBaseRegex.test(config.url)) {
        config.url = config.url.replace(apiBaseRegex, icrApiBasePath)
      }
      return config
    }
  }

}
