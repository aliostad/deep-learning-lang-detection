function myalert(message){
	jQuery.messager.alert('提示',message);
}

function myerror(message){
	jQuery.messager.alert('错误',message,"error");
}


function myinfo(message){
	jQuery.messager.alert('信息',message,"info");
}

function myquestion(message){
	jQuery.messager.alert('确认',message,"question");
}

function mywarning(message){
	jQuery.messager.alert('警告',message,"warning");
}

function myconfirm(message,fun){
	jQuery.messager.confirm('确认', message, function(r){
		if(r){
			if(fun)
			fun();
		}
	});
}












