/// Config's service
angular.module('trainme').service('configService', ['$http', 'uidService', function configService($http, uidService){
	
	var config = {
									user: {
													uid: uidService.GetUid()
												},
									backend: 
													{
														restServiceUrl: ''
													}
								};
								
	$http.get('config.json')
				.success(function(response){ 
						config.backend.restServiceUrl = response.data.backend.restServiceUrl; ///? check if it work or not
					});
	
	this.Config = config;
	
}]);