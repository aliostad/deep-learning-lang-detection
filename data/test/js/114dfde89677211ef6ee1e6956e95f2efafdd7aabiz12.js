//model start		
Ext.define('serviceTypeModel', {
	extend: 'Ext.data.Model',
	fields: [{
		name: 'serviceType_id', type: 'string'
	}, {
		name: 'serviceTypeName', type: 'string'
	}]
});

Ext.define('serviceComboModel', {
	extend: 'Ext.data.Model',
	fields: [{
		name: 'service_id', type: 'string'
	}, {
		name: 'serviceName', type: 'string'
	}]
});
//model end
//store start
//bank combo store

var serviceComboStore = new Ext.data.Store({
	autoLoad: true,
	model: 'serviceComboModel',
	proxy: {
		type: 'ajax',
		url: 'biz/serviceCombo.action',
		reader: {
			type: 'json',
			root: 'serviceCombos'
		}
	}
});
serviceComboStore.load();
/*
var serviceComboStore = new Ext.data.Store({
	fields: ['service_id', 'serviceName'],
	data: [{
		"service_id": "1", "serviceName": "test1"
	}, {
		"service_id": "2", "serviceName": "test2"
	}]
});
*/
var serviceTypeComboStore = new Ext.data.Store({
	fields: ['serviceType_id', 'serviceTypeName'],
	data: [{
		"serviceType_id": "1", "serviceTypeName": "代理业务"
	}, {
		"serviceType_id": "2", "serviceTypeName": "转账业务"
	}, {
		"serviceType_id": "3", "serviceTypeName": "汇率业务"
	}, {
		"serviceType_id": "4", "serviceTypeName": "信托业务"
	}]
});

//store end