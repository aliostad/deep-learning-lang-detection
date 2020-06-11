package com.xwtech.xwecp.service.logic.pojo;

import com.xwtech.xwecp.service.BaseServiceInvocationResult;
import java.util.List;
import java.util.ArrayList;
import com.xwtech.xwecp.service.logic.pojo.ServiceInfo;

public class QRY050023Result extends BaseServiceInvocationResult
{
	private List<ServiceInfo> serviceInfos = new ArrayList<ServiceInfo>();

	public void setServiceInfos(List<ServiceInfo> serviceInfos)
	{
		this.serviceInfos = serviceInfos;
	}

	public List<ServiceInfo> getServiceInfos()
	{
		return this.serviceInfos;
	}

}