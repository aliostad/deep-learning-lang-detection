package com.sean.im.client.core;

import java.util.HashMap;
import java.util.Map;

import com.sean.im.client.push.handler.DeleteFriendHandler;
import com.sean.im.client.push.handler.DismissFlockHandler;
import com.sean.im.client.push.handler.ExitHandler;
import com.sean.im.client.push.handler.GrantOrTakeBackFlockAdminHandler;
import com.sean.im.client.push.handler.JoinInFlockHandler;
import com.sean.im.client.push.handler.KickOutFlockHandler;
import com.sean.im.client.push.handler.ReceiveFileHandler;
import com.sean.im.client.push.handler.ReceiveFlockFileHandler;
import com.sean.im.client.push.handler.ReceiveFlockMsgHandler;
import com.sean.im.client.push.handler.ReceiveMsgHandler;
import com.sean.im.client.push.handler.ReceiveWarnMsgHandler;
import com.sean.im.client.push.handler.RequestFriendHandler;
import com.sean.im.client.push.handler.RequestFriendResultHandler;
import com.sean.im.client.push.handler.StatusChangedHandler;
import com.sean.im.client.push.handler.TrembleHandler;
import com.sean.im.commom.constant.Actions;
import com.sean.im.commom.core.Protocol;

public class PushHandlerImpl implements PushHandler
{
	private Map<String, PushHandler> handlers = new HashMap<String, PushHandler>();
	private boolean isClosed = false;

	public PushHandlerImpl()
	{
		handlers.put(Actions.StatusChangedHandler, new StatusChangedHandler());
		handlers.put(Actions.DeleteFriendHandler, new DeleteFriendHandler());
		handlers.put(Actions.ReceiveMsgHandler, new ReceiveMsgHandler());
		handlers.put(Actions.ReceiveWarnMsgHandler, new ReceiveWarnMsgHandler());
		handlers.put(Actions.RequestFriendHandler, new RequestFriendHandler());
		handlers.put(Actions.RequestFriendResultHandler, new RequestFriendResultHandler());
		handlers.put(Actions.ExitHandler, new ExitHandler());
		handlers.put(Actions.ReceiveFileHandler, new ReceiveFileHandler());
		handlers.put(Actions.TrembleHandler, new TrembleHandler());
		
		// flock module
		handlers.put(Actions.ReceiveFlockMsgHandler, new ReceiveFlockMsgHandler());
		handlers.put(Actions.ReceiveFlockFileHandler, new ReceiveFlockFileHandler());
		handlers.put(Actions.GrantOrTakeBackFlockAdminHandler, new GrantOrTakeBackFlockAdminHandler());
		handlers.put(Actions.KickOutFlockHandler, new KickOutFlockHandler());
		handlers.put(Actions.JoinInFlockHandler, new JoinInFlockHandler());
		handlers.put(Actions.DismissFlockHandler, new DismissFlockHandler());
	}

	@Override
	public void execute(Protocol protocol)
	{
		synchronized (this)
		{
			PushHandler handler = handlers.get(protocol.action);
			if (handler != null)
			{
				if (!isClosed)
				{
					if (protocol.action.equals(Actions.ExitHandler))
					{
						isClosed = true;
						try
						{
							ApplicationContext.Client.close();
						}
						catch (Exception e)
						{
							e.printStackTrace();
						}
					}
					handler.execute(protocol);
				}
			}
		}
	}
}
