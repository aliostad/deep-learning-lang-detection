package mr.xuckz.monitoringTool.web.services;

import mr.xuckz.monitoringTool.handler.StatusHandler;
import mr.xuckz.monitoringTool.web.model.Status;

public class StatusService
{
	private StatusHandler statusHandler;

    public StatusService()
	{

	}

    public Status retrieveStatus(String ip)
    {
        Status status = StatusHandler.retrieveStatus(ip);

        return status;
    }

    public StatusHandler getStatusHandler()
    {
        return statusHandler;
    }

    public void setStatusHandler(StatusHandler statusHandler)
    {
        this.statusHandler = statusHandler;
    }
}
