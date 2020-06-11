define(
	['knockout', 
	'knockout-postbox' , 
	'jquery' ,
	'underscore', 
	'./src/serviceTypeModule'],
	function(ko, postbox, $, _, serviceTypeModule) {

		return function serviceTypeController(){

			var self;

			self = this;
			serviceTypeModule.initConnection("", "/DisasterMgmnt");


			self.approvedServiceType = ko.observableArray([]);
			self.pendingServiceType = ko.observableArray([]);
			self.serviceType = ko.observable(new serviceTypeModule.ServiceType({}));
 
			serviceTypeModule.getServiceTypes(function(services){
					self.approvedServiceType.removeAll();
					self.pendingServiceType.removeAll();
				_.each(services, function(service) {
					if(service.approved === true){
						self.approvedServiceType.push(service);
					}else {
						self.pendingServiceType.push(service);
					}
				})
				if(self.pendingServiceType.length == 0){
					$(".pending-services").alert('close')
				}
			});
		
			self.approveService = function(data){
				console.log("clicked approved");
				data.approved = true
				serviceTypeModule.updateServiceType(data, function(data){
				self.pendingServiceType( 
					_.reject(self.pendingServiceType(), function(serviceType) {return serviceType.id == data.id; }) 
					)
				self.approvedServiceType.push(data);
				},function(err){
					console.log(err)
				})

			}
			self.denyService = function(data){
				console.log("clicked deny")
				console.log(data);
			}
			self.editServiceType = function(data){
				$('.editServiceType').toggleClass('hidden');
				$('.manageServices').toggleClass('hidden');
				self.serviceType(data);
			}
			self.submitEdit = function(){
				var data = self.serviceType();
				serviceTypeModule.updateServiceType(data, function(data){
					console.log(data);
					if(!data.approved){
						self.approvedServiceType( 
						_.reject(self.approvedServiceType(), function(serviceType) {return serviceType.id == data.id; }) 
						)
						self.pendingServiceType.push(data);
					}
					$('.editServiceType').toggleClass('hidden');
					$('.manageServices').toggleClass('hidden');
				},function(err){
					console.log(err)
				})

			}
		} 
});
