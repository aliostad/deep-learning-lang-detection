export const getalltype = () => (dispatch , getState) => {
	$.get("php/getalltype.php",function(data){
		if(typeof data != "object"){
			data = JSON.parse(data);
		}
		dispatch({"type":"GETALLTYPE" , "alltypes" : data});
	});
}

//得到所有标题
export const getbrief = (dongxistr,cb) => (dispatch , getState) => {
	if(dongxistr === undefined){
		dongxistr = "all";
	}

	$.get("php/gettiezibrief.php",{"type":dongxistr,"page":getState().indexReducer.page},function(data){
		if(typeof data != "object"){
			data = JSON.parse(data);
		}
		dispatch({"type":"GETALLBIAOTI" , "allbriefs" : data});
		if(cb != undefined){
			cb(data.length);  //执行回调函数
		}
	});
}


//更改登录框的显示状态
export const showloginbox = (torf) => (dispatch , getState) => {
 	dispatch({"type":"SHOWLOGINBOX" , "v" :torf });
}
 
//更改注册框的显示状态
export const showregistbox = (torf) => (dispatch , getState) => {
 	dispatch({"type":"SHOWREGISTBOX" , "v" :torf });
}

//注册
export const doregist = (username,password,callback) => (dispatch , getState) =>{
	$.post("php/doregist.php",{username:username , password : password},function(data){
		if(data == 1){
			//上达天听
			dispatch({"type":"REGISTSUCCESS"});
		} 

		//给DOM，让DOM能够有一个界面反馈给用的
		callback(data);
	});
}

//登录
export const dologin = (username,password,callback) => (dispatch , getState) => {
	$.post("php/dologin.php",{username:username , password : password},function(data){
		//上大天听
		dispatch({"type" : "LOGINSUCCESS" , "username" : username});
		//返回给DOM
		callback(data);
	});
}
export const logout = (username) => (dispatch , getState) => {
	dispatch({"type":"LOGOUT"})
	$.get("php/logout.php",{username:username},function(data){
		//上大天听
		dispatch({"type" : "LOGOUT" , "username" : username});
		//返回给DOM
	});
}
//检查登录
export const checklogin = () => (dispatch) => {
	$.get("php/checklogin.php",function(data){
		//转为对象
		if(typeof data != "object"){
			data = JSON.parse(data);
		}

		//上大天听
		dispatch({"type" : "CHECKLOGIN" , "login" : data.login , "username" : data.username});
	});
}


//发表
export const dofabiao = (title,content,leixing,cb) => (dispatch) => {
	$.post("php/fabiao.php",{title,content,leixing},function(data){
		 cb(data)
		//上大天听
		dispatch({"type" : "FABIAO"});
	});
}


export const gettiezi = (id) => (dispatch) => {
	$.get("php/gettiezi.php?id=" + id,function(data){
		 
		//改变state，这个state也会设置showcontentbox，二合一了，
		//又获得了服务器中的帖子数据，同时显示了帖子。
		dispatch({"type" : "GETTIEZI" , "tiezi" : data , "cid" : id});
	});
}


export const guanbicontent = () => (dispatch) => {
	//改变state
	dispatch({"type" : "GUANBICONTENT" });
}


//页面下滚
export const pagejia = () => (dispatch) => {
	//改变state
	dispatch({"type" : "PAGEJIA" });
}


//设置锁的方法
export const shezhilock = (trueorfalse) => (dispatch) => {
 	console.log("shezhilock" , trueorfalse)
	//改变state
	dispatch({"type" : "SHEZHILOCK"  ,"lock" : trueorfalse});
}


//复原
export const fuyuan = () => (dispatch) => {
	//改变state
	dispatch({"type" : "FUYUAN"});
}

//设置东西
export const shezhidongxi = (str) => (dispatch) => {
	//改变state
	dispatch({"type" : "SHEZHIDONGXI" , "dongxi" : str});
}
