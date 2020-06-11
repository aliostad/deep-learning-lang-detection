this.wdf = this.wdf || {}; 

(function(){
	
	var ServiceID = function(){}
	
    ServiceID.COMMUNICATION = 'sComm';
    ServiceID.AMF = 'sAMF';
    ServiceID.DATABASE = 'sDatabase';
    ServiceID.USER = 'sUser';
    ServiceID.EXPRESS_IO = 'sExpressIO';
    ServiceID.PMX = 'sPMX';
    ServiceID.SOCKET_CLIENT = 'sSocketClient';
    ServiceID.HTTP_REQUEST = 'sHttpRequest';
    ServiceID.GAME_TABLE = 'sGameTable';
    ServiceID.GAME_MP_TABLE = 'sGameMPTable';
    ServiceID.QUEUE = 'sQueue';
    
wdf.ServiceID = ServiceID;
}());