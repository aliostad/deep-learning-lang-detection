package com.jiangqq.bean;

import java.io.Serializable;
import java.util.List;

public class ProcessProto implements Serializable{

	private static final long serialVersionUID = 291840695327749317L;
	private String name;
	private List<ProcessActivity> processActivities;

	public ProcessProto() {
		super();
	}

	public ProcessProto(String name, List<ProcessActivity> processActivities) {
		super();
		this.name = name;
		this.processActivities = processActivities;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public List<ProcessActivity> getProcessActivities() {
		return processActivities;
	}

	public void setProcessActivities(List<ProcessActivity> processActivities) {
		this.processActivities = processActivities;
	}

	@Override
	public String toString() {
		return "Process [name=" + name + ", processActivities="
				+ processActivities + "]";
	}

}
