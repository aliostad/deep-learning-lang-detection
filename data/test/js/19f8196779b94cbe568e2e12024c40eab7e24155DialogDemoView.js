Ext.define('ems.biz.demo.widgetdemo.view.DialogDemoView', {
    extend: 'ems.core.UI',
	
	uiConfig: function() {
		var me = this;
		return {
			defaultType: 'button',
			defaults: {
				margin:'5'
			},
			items: [{
				text: 'showInfoDialog',
				listeners: {
					click: function() {
						EU.showInfoDialog({
							title: 'title-showInfoDialog',
							msg: 'msg-showInfoDialog'
						})
					}
				}
			}, {
				text: 'showWarningDialog',
				listeners: {
					click: function() {
						EU.showWarningDialog({
							title: 'title-showWarningDialog',
							msg: 'msg-showWarningDialog'
						})
					}
				}
			}, {
				text: 'showConfirmDialog',
				listeners: {
					click: function() {
						EU.showInfoDialog({
							title: 'title-showConfirmDialog',
							msg: 'msg-showConfirmDialog'
						})
					}
				}
			}, {
				text: 'showErrorDialog',
				listeners: {
					click: function() {
						EU.showErrorDialog({
							title: 'title-showErrorDialog',
							msg: 'msg-showErrorDialog'
						})
					}
				}
			}]
		};
	}
	
});