/*
 */
package org.realtors.rets.server.webapp.cct;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.realtors.rets.server.cct.ValidationResult;

/**
 * Provides access to all available RETS handlers
 */
public class RetsHandlers
{
    public RetsHandlers()
    {
        mHandlersByName = new HashMap();
        mHandlerList = new ArrayList();
        add(new ActionHandler());
        add(new LoginHandler());
        add(new LogoutHandler());
        add(new GetMetadataHandler());
    }

    private void add(ServletHandler handler)
    {
        mHandlersByName.put(handler.getName(), handler);
        mHandlerList.add(handler);
    }

    /**
     * Resets all handlers
     */
    public void resetAll()
    {
        for (int i = 0; i < mHandlerList.size(); i++)
        {
            ServletHandler handler = (ServletHandler) mHandlerList.get(i);
            handler.reset();
        }
    }

    public void validateAll(ValidationResult result)
    {
        for (int i = 0; i < mHandlerList.size(); i++)
        {
            ServletHandler handler = (ServletHandler) mHandlerList.get(i);
            handler.validate(result);
        }
    }

    public ServletHandler getByName(String name)
    {
        return (ServletHandler) mHandlersByName.get(name);
    }

    public ActionHandler getActionHandler()
    {
        return (ActionHandler) mHandlersByName.get(ActionHandler.NAME);
    }

    public GetMetadataHandler getGetMetadataHandler()
    {
        return (GetMetadataHandler)
            mHandlersByName.get(GetMetadataHandler.NAME);
    }

    public LoginHandler getLoginHandler()
    {
        return (LoginHandler) mHandlersByName.get(LoginHandler.NAME);
    }

    public LogoutHandler getLogoutHandler()
    {
        return (LogoutHandler) mHandlersByName.get(LogoutHandler.NAME);
    }

    private Map mHandlersByName;
    private List mHandlerList;
}
