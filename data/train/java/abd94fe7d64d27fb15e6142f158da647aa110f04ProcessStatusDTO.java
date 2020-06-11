package edu.dlsu.mips.dto;

import edu.dlsu.mips.domain.ProcessStatus;

public class ProcessStatusDTO {
	private static ProcessStatusDTO processStatusDTO;
	
	static{
		processStatusDTO = new ProcessStatusDTO();
	}
	
	public static ProcessStatusDTO getInstance(){
		return processStatusDTO;
	}
	
	private ProcessStatus processStatus;
	private Integer jumpTo;
	
	public void setProcessStatus(ProcessStatus processStatus){
		this.processStatus = processStatus;
	}
	
	public void setJumpTo(Integer jumpTo){
		this.jumpTo = jumpTo;
	}
	
	public ProcessStatus getProcessStatus(){
		return processStatus;
	}
	
	public Integer getJumpTo(){
		return jumpTo;
	}
	
	
	
}
