package com.nexus.api;

import com.nexus.api.handlers.*;
import com.nexus.interfaces.IStaticLoader;
import com.nexus.logging.NexusLog;

public class ApiFunctionLoader implements IStaticLoader{
	
	@Override
	public void Load(){
		ApiHandler.RegisterHandler("/getVersion/", ApiHandlerGetVersion.class);
		ApiHandler.RegisterHandler("/killToken/", ApiHandlerKillToken.class);
		ApiHandler.RegisterHandler("/keepAlive/", ApiHandlerKeepTokenAlive.class);
		ApiHandler.RegisterHandler("/getWebsocketURL/", ApiHandlerGetWebsocketURL.class);
		ApiHandler.RegisterHandler("/getTime/", ApiHandlerGetTime.class);
		ApiHandler.RegisterHandler("/register/", ApiHandlerRegisterClient.class);
		ApiHandler.RegisterHandler("/restartServer/", ApiHandlerRestartServer.class);
		ApiHandler.RegisterHandler("/stopServer/", ApiHandlerStopServer.class);
		ApiHandler.RegisterHandler("/getAuthorizedModules/", ApiHandlerGetAuthorizedModules.class);
		ApiHandler.RegisterHandler("/getToken/", ApiHandlerGetToken.class);
		ApiHandler.RegisterHandler("/getAirtimeData/", ApiHandlerGetAirtimeData.class);
		ApiHandler.RegisterHandler("/changeEmail/", ApiHandlerChangeUserEmail.class);
		ApiHandler.RegisterHandler("/sendResetPassword/", ApiHandlerSendResetPasswordLink.class);
		ApiHandler.RegisterHandler("/addUser/", ApiHandlerAddUser.class);
		ApiHandler.RegisterHandler("/twitterCallback/", ApiHandlerTwitterCallback.class);
		ApiHandler.RegisterHandler("/twitterAuthorize/", ApiHandlerTwitterGetAuthorizationURL.class);
		ApiHandler.RegisterHandler("/airtime/([0-9]+)/([0-9]+)/([0-9]+)/(.*)/", ApiHandlerAirtimeByDate.class);
		ApiHandler.RegisterHandler("/getUserConversations/", ApiHandlerGetUserConversations.class);
		ApiHandler.RegisterHandler("/userInfo/", ApiHandlerUserInfo.class);
		ApiHandler.RegisterHandler("/listUsers/", ApiHandlerListUsers.class);
		
		NexusLog.info("Registered %d API Handlers", ApiHandler.GetHandlers().size());
	}
}
