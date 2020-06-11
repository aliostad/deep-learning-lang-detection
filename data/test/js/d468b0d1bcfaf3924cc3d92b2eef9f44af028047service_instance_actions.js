import { getData, postData, updateData, removeData } from './requestHelper';

export function purchaseServiceInstances(serviceInstances) {
	return {
		type: 'PURCHASE_SERVICE_INSTANCES',
		data: serviceInstances
	}
}

export function buyServiceInstances(serviceInstances) {
	return (dispatch) => {
		updateData('orders', serviceInstances)
		.then((response) => {
			console.log(response);
			dispatch(purchaseServiceInstances(serviceInstances));
		})
	};
}

export function setServiceInstances(serviceInstances) {
	return {
		type: 'SET_SERVICE_INSTANCES',
		data: serviceInstances
	};
}

export function getServiceInstances() {
	return (dispatch) => {
		getData('serviceInstances')
		.then((serviceInstances) => {
			dispatch(setServiceInstances(serviceInstances));
		})
		.catch((error) => {
			throw error;
		})
	}
}

export function addServiceInstance(serviceInstance) {
	return {
		type: 'ADD_SERVICE_INSTANCE',
		data: serviceInstance
	};
}
export function addToCart(serviceInstance) {
	return (dispatch) => {
		postData('serviceInstances', serviceInstance)
		.then((responseObj) => {
			serviceInstance.id = responseObj.id;
			dispatch(addServiceInstance(serviceInstance));
		});
	}
}

export function removeFromCart(data) {
	console.log(data);
	removeData('serviceInstances', data)
	.catch((error) => {
		throw error;
	});

	return {
		type: 'REMOVE_SERVICE_INSTANCE',
		data
	};
}

