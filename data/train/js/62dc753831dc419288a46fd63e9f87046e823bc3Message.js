var Message;     
if(!Message) Message = function(a,m,p){
	this.a=a;
	this.m=m;
	this.p=p;
};
//显示文字信息
Message.showMsg=function(msg){
	var chatlog=document.getElementById("chatlog");
	chatlog.textContent +=msg;
	chatlog.scrollTop = chatlog.scrollHeight;
};
Message.W=0;
Message.D=1;
Message.S=2;
Message.A=3;
Message.KILL=4;
Message.SHOT=5;
Message.LOGIN=6;
Message.LOGOUT=7;
Message.TALK=8;
Message.ERROR=9;
Message.READLY=10;
Message.RELEASE=11;
Message.START=12;
Message.PLAYERSTATUS=13;
Message.CLEARWDSA=14;
