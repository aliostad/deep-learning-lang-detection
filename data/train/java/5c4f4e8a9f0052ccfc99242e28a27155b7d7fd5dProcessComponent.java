package com.ns.deneme.neo4j.domain;

import org.neo4j.graphdb.Direction;
import org.springframework.data.neo4j.annotation.Fetch;
import org.springframework.data.neo4j.annotation.Indexed;
import org.springframework.data.neo4j.annotation.NodeEntity;
import org.springframework.data.neo4j.annotation.RelatedTo;

@SuppressWarnings("serial")
@NodeEntity
public class ProcessComponent extends AbstractEntity {

	@Indexed(unique = true)
	private String processName;

	private String processType;

	private String positionLeft;

	private String positionTop;

	@Fetch
	@RelatedTo(type = "hasConfig", direction = Direction.OUTGOING)
	private ProcessConfig processConfig;

	@Fetch
	@RelatedTo(type = "hasNextProcess", direction = Direction.OUTGOING)
	private ProcessComponent nextProcess;

	public String getProcessName() {
		return processName;
	}

	public void setProcessName(String processName) {
		this.processName = processName;
	}

	public String getProcessType() {
		return processType;
	}

	public void setProcessType(String processType) {
		this.processType = processType;
	}

	public String getPositionLeft() {
		return positionLeft;
	}

	public void setPositionLeft(String positionLeft) {
		this.positionLeft = positionLeft;
	}

	public String getPositionTop() {
		return positionTop;
	}

	public void setPositionTop(String positionTop) {
		this.positionTop = positionTop;
	}

	public ProcessConfig getProcessConfig() {
		return processConfig;
	}

	public void setProcessConfig(ProcessConfig processConfig) {
		this.processConfig = processConfig;
	}

	public ProcessComponent getNextProcess() {
		return nextProcess;
	}

	public void setNextProcess(ProcessComponent nextProcess) {
		this.nextProcess = nextProcess;
	}

}