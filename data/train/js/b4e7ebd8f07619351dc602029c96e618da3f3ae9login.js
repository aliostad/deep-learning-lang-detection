apiready = function(){
	$api.addEvt($api.byId('login'), 'click', function(){
		api.ajax({
	        url:API_URL.app_login,
	        method:'post',
	        dataType:'JSON',
	        data:{
	        	values:{
	        		username:$api.val($api.byId('username')),
	        		password:$api.val($api.byId('password'))
	        	}
	        }
        },function(ret,err){
            if(ret['res'] == 0){
				api.openWin({
        		    name: 'main',
        		    url: '../window_index.html',
        		});
            } else {
            	api.alert({
            	    title: '登陆',
            	    msg: ret['res'],
            	});
            }
        });
    });
};