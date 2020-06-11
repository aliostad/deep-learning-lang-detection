CasterApp.factory('notificacionServ', function() {

	notify = function(message){
		var iconset = {info:"glyphicon glyphicon-info-sign", success:"glyphicon glyphicon-ok-sign", warning:"glyphicon glyphicon-warning-sign", danger:"glyphicon glyphicon-remove-sign"};

		return $.notify({ icon: message.icon ? message.icon : iconset[message.type], title: '<b>'+message.title+'</b><br>', message:(message.message) ? message.message : message }, { type:message.type, delay: message.delay, z_index:1051 });
	};

    return {
        generalInfo : function(message){
            notify({title: 'Nota', message: message, type:"info"});
        },
        generalSuccess : function(message){
            notify({title: 'Éxito', message: message, type:"success"});
        },
        generalWarning : function(message){
            notify({title: 'Advertencia', message: message, type:"warning"});
        },
        generalError : function(message){
            notify({title: 'Error', message: message, type:"danger"});
        },
  	};
});

