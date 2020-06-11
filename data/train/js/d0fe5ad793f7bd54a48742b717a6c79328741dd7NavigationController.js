ToyotaFriend.Navigation = function() {
	this.backUtil = {
		dispatchQueue: []
	};
};

ToyotaFriend.Navigation.prototype.updateRouteObject = function(routeObj) {
	if(this.dispatchQueue && this.dispatchQueue.length) {
		var currentDispatch = this.dispatchQueue.pop();
		this.registerRouteObject(routeObj);
	}
};


ToyotaFriend.Navigation.prototype.isRepeatDispatch = function(routeObj) {
	var isRepeatDispatch = false;
	
	var currentDispatchIndex = this.dispatchQueue.length - 1;
	if(currentDispatchIndex >= 0) {
		var currentDispatch = this.dispatchQueue[currentDispatchIndex];
		if(currentDispatch) {
			if((currentDispatch.controller) &&
				(routeObj.controller) &&
				(routeObj.controller.id == currentDispatch.controller.id) &&
				(currentDispatch.action) &&
				(routeObj.action) &&
				(currentDispatch.action == routeObj.action)) {
					isRepeatDispatch = true;
				}
		}
	}
	
	return isRepeatDispatch;
};

ToyotaFriend.Navigation.prototype.registerRouteObject = function(routeObj) {
	if(this.dispatchQueue) {
		var isDuplicateDispatch = false;
		
		var currentDispatchIndex = this.dispatchQueue.length - 1;
		if(currentDispatchIndex >= 0) {
			var currentDispatch = this.dispatchQueue[currentDispatchIndex];
			if(currentDispatch) {
				if((currentDispatch.controller) &&
					(routeObj.controller) &&
					(routeObj.controller.id == currentDispatch.controller.id) &&
					(currentDispatch.action) &&
					(routeObj.action) &&
					(currentDispatch.action == routeObj.action)) {
						isDuplicateDispatch = true;
						if(currentDispatch.parameter &&
							routeObj.parameter &&
							(routeObj.parameter != currentDispatch.parameter)) {
								isDuplicateDispatch = false;
							}
					}
			}
		}
		
		if(!isDuplicateDispatch) {
			routeObj.activeTab = ToyotaFriend.viewport.getActiveItem();
			this.dispatchQueue.push(routeObj);
		}
	}
};

ToyotaFriend.Navigation.prototype.goBack = function(refresh) {
	if(this.dispatchQueue) {
		var currentDispatch = this.dispatchQueue.pop();
		if(currentDispatch) {
			var backDispatch = this.dispatchQueue.pop();
			if(backDispatch) {
				if (refresh !== true) {
					refresh = false;
				}
				
				var animation = { type: 'slide', direction: 'right' };
				if (currentDispatch.activeTab &&
					backDispatch.activeTab &&
					(currentDispatch.activeTab !== backDispatch.activeTab)) {
						animation = null;
						backDispatch.activeTab.resetToIndex = false;
						ToyotaFriend.viewport.setActiveItem(backDispatch.activeTab);
				}
				
				// Enabling back animation and passing refresh toggle
				Ext.apply(backDispatch, {
					animation: animation,
					refreshData: refresh
				});
				
				Ext.dispatch(backDispatch);
			}
		}
	}
};