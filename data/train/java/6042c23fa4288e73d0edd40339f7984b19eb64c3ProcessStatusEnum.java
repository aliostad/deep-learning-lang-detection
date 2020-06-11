package com.ltxc.google.csms.shared;



public enum ProcessStatusEnum {

	NONE("NONE",0),
	NEW("NEW",1),
	SUBMITTED("SUBMITTED",2),
	PROCESSING("PROCESSING",3),
	VALIDATIONFAILURE("VALIDATIONFAILURE",4),
	FAILED("FAILED",5),
	COMPLETED("COMPLETED",6);	
	

	public String getProcessStatusName() {
		return processStatusName;
	}


	public int getProcessStatus() {
		return processStatus;
	}


	private String processStatusName;
	private int processStatus;
	
	ProcessStatusEnum(String processStatusName, int processStatus)
	{
			this.processStatusName = processStatusName;
			this.processStatus = processStatus;		
	}
	
	public static ProcessStatusEnum parse(int processStatus) throws Exception
	{
		ProcessStatusEnum processStatusEnum;
		switch(processStatus)
		{
			case 1: processStatusEnum = ProcessStatusEnum.NEW;break;
			case 2: processStatusEnum = ProcessStatusEnum.SUBMITTED;break;
			case 3: processStatusEnum = ProcessStatusEnum.PROCESSING;break;
			case 4: processStatusEnum = ProcessStatusEnum.VALIDATIONFAILURE;break;
			case 5: processStatusEnum = ProcessStatusEnum.FAILED;break;
			case 6: processStatusEnum = ProcessStatusEnum.COMPLETED;break;

			default:throw new Exception("Failed to parse "+processStatus+" to any enum type.");
		}
		
		return processStatusEnum;
	}
	
	public static ProcessStatusEnum parse(String processStatusName) throws Exception
	{
		ProcessStatusEnum value = ProcessStatusEnum.NONE;
		if (processStatusName!=null)
		{
			String r = processStatusName.trim();
			if (r.equalsIgnoreCase(ProcessStatusEnum.NEW.getProcessStatusName()))
				value = ProcessStatusEnum.NEW;
			else if (r.equalsIgnoreCase(ProcessStatusEnum.SUBMITTED.getProcessStatusName()))
				value = ProcessStatusEnum.SUBMITTED;
			else if (r.equalsIgnoreCase(ProcessStatusEnum.PROCESSING.getProcessStatusName()))
				value = ProcessStatusEnum.PROCESSING;
			else if (r.equalsIgnoreCase(ProcessStatusEnum.VALIDATIONFAILURE.getProcessStatusName()))
				value = ProcessStatusEnum.VALIDATIONFAILURE;
			else if (r.equalsIgnoreCase(ProcessStatusEnum.FAILED.getProcessStatusName()))
				value = ProcessStatusEnum.FAILED;
			else if (r.equalsIgnoreCase(ProcessStatusEnum.COMPLETED.getProcessStatusName()))
				value = ProcessStatusEnum.COMPLETED;
		}		
		return value;
	}
	
}