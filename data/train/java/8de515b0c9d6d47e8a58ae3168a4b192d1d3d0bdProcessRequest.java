package com.sensus.mlc.process.model.request;

import java.util.ArrayList;
import java.util.List;

import com.sensus.common.model.UserContext;
import com.sensus.mlc.base.model.request.LightingControlInquiryRequest;
import com.sensus.mlc.process.model.Process;
import com.sensus.mlc.process.model.ProcessFilter;
import com.sensus.mlc.process.model.ProcessItem;
import com.sensus.mlc.process.model.ProcessItemStatusEnum;
import com.sensus.mlc.process.model.ProcessStatusReasonEnum;
import com.sensus.mlc.tenant.model.Tenant;

/**
 * The Class ProcessRequest.
 */
public class ProcessRequest extends LightingControlInquiryRequest
{

	/** The Constant FIRST_RESULT. */
	private static final int FIRST_RESULT = 0;

	/** The process list. */
	private List<Process> processList = new ArrayList<Process>();

	/** The process filter. */
	private ProcessFilter processFilter;

	/** The process item status enum. */
	private ProcessItemStatusEnum processItemStatusEnum;

	/** The process status reason enum. */
	private ProcessStatusReasonEnum processStatusReasonEnum;

	/** The insert by fetch. */
	private List<ProcessItem> processItemFailureList;

	/**
	 * Instantiates a new process request.
	 */
	public ProcessRequest()
	{
	}

	/**
	 * Create a new process request.
	 * 
	 * @param userContext the user context
	 */
	public ProcessRequest(UserContext userContext)
	{
		super(userContext);
	}

	/**
	 * Create a new process request.
	 * 
	 * @param process the process
	 * @param tenant the tenant
	 * @param userContext the user context
	 */
	public ProcessRequest(final Process process, final Tenant tenant, final UserContext userContext)
	{
		super(userContext, tenant);
		setProcess(process);
	}

	/**
	 * Sets the process list.
	 * 
	 * @param processListParam the new process list
	 */
	public void setProcessList(List<Process> processListParam)
	{
		processList = processListParam;
	}

	/**
	 * Gets the process.
	 * 
	 * @return the process
	 */
	public Process getProcess()
	{
		if ((getProcessList() == null) || getProcessList().isEmpty())
		{
			return null;
		}
		return getProcessList().get(FIRST_RESULT);
	}

	/**
	 * Sets the process.
	 * 
	 * @param processParam the new process
	 */
	public void setProcess(Process processParam)
	{
		getProcessList().add(processParam);
	}

	/**
	 * Gets the process list.
	 * 
	 * @return the process list
	 */
	public List<Process> getProcessList()
	{
		return processList;
	}

	/**
	 * Gets the process filter.
	 * 
	 * @return the process filter
	 */
	public ProcessFilter getProcessFilter()
	{
		return processFilter;
	}

	/**
	 * Sets the process filter.
	 * 
	 * @param processFilter the new process filter
	 */
	public void setProcessFilter(ProcessFilter processFilter)
	{
		this.processFilter = processFilter;
	}

	/**
	 * Gets the process item status enum.
	 * 
	 * @return the process item status enum
	 */
	public ProcessItemStatusEnum getProcessItemStatusEnum()
	{
		return processItemStatusEnum;
	}

	/**
	 * Sets the process item status enum.
	 * 
	 * @param processItemStatusEnum the new process item status enum
	 */
	public void setProcessItemStatusEnum(ProcessItemStatusEnum processItemStatusEnum)
	{
		this.processItemStatusEnum = processItemStatusEnum;
	}

	/**
	 * Gets the process item status enum value.
	 * 
	 * @return the process item status enum value
	 */
	public Integer getProcessItemStatusEnumValue()
	{
		if (getProcessItemStatusEnum() == null)
		{
			return null;
		}
		return getProcessItemStatusEnum().getValue();
	}

	/**
	 * Gets the process status reason enum.
	 * 
	 * @return the process status reason enum
	 */
	public ProcessStatusReasonEnum getProcessStatusReasonEnum()
	{
		return processStatusReasonEnum;
	}

	/**
	 * Sets the process status reason enum.
	 * 
	 * @param processStatusReasonEnum the new process status reason enum
	 */
	public void setProcessStatusReasonEnum(ProcessStatusReasonEnum processStatusReasonEnum)
	{
		this.processStatusReasonEnum = processStatusReasonEnum;
	}

	/**
	 * Gets the process status reason enum value.
	 * 
	 * @return the process status reason enum value
	 */
	public Integer getProcessStatusReasonEnumValue()
	{
		if (getProcessStatusReasonEnum() == null)
		{
			return null;
		}
		return getProcessStatusReasonEnum().getValue();
	}

	public List<ProcessItem> getProcessItemFailureList()
	{
		return processItemFailureList;
	}

	public void setProcessItemFailureList(List<ProcessItem> processItemFailureList)
	{
		this.processItemFailureList = processItemFailureList;
	}

	@Override
	public String toString()
	{
		return "ProcessRequest [getProcess()=" + getProcess() + ", getProcessList()=" + getProcessList()
				+ ", getProcessFilter()=" + getProcessFilter() + ", getProcessItemStatusEnum()="
				+ getProcessItemStatusEnum() + ", getProcessItemStatusEnumValue()=" + getProcessItemStatusEnumValue()
				+ ", getProcessStatusReasonEnum()=" + getProcessStatusReasonEnum()
				+ ", getProcessStatusReasonEnumValue()=" + getProcessStatusReasonEnumValue()
				+ ", getProcessItemFailureList()=" + getProcessItemFailureList() + ", getStartRow()=" + getStartRow()
				+ ", getEndRow()=" + getEndRow() + ", getPageSize()=" + getPageSize() + ", getStartPage()="
				+ getStartPage() + ", getSortExpressions()=" + getSortExpressions() + ", getSortExpression()="
				+ getSortExpression() + ", isPreQueryCount()=" + isPreQueryCount() + ", getMaxPreQueryCount()="
				+ getMaxPreQueryCount() + ", getListColumn()=" + getListColumn() + ", isMonitored()=" + isMonitored()
				+ ", getSearchLight()=" + getSearchLight() + ", getPaginationAllSelected()="
				+ getPaginationAllSelected() + ", getSelectionPaginationIds()=" + getSelectionPaginationIds()
				+ ", getUnselectionPaginationIds()=" + getUnselectionPaginationIds() + ", isCurrentLightStatus()="
				+ isCurrentLightStatus() + ", getBottomLeftLat()=" + getBottomLeftLat() + ", getBottomLeftLon()="
				+ getBottomLeftLon() + ", getTopRightLat()=" + getTopRightLat() + ", getTopRightLon()="
				+ getTopRightLon() + ", getMaxSmartpointCount()=" + getMaxSmartpointCount() + ", getTenant()="
				+ getTenant() + ", getAllowedGroupIdList()=" + getAllowedGroupIdList() + ", getStringAllowedGroups()="
				+ getStringAllowedGroups() + ", getTimezone()=" + getTimezone() + ", getDatePattern()="
				+ getDatePattern() + ", getUserContext()=" + getUserContext() + "]";
	}
}
