package com.gdn.venice.persistence;

import java.io.Serializable;
import javax.persistence.*;

import java.util.List;


/**
 * The persistent class for the raf_process database table.
 * 
 */
@Entity
@Table(name="raf_process")
public class RafProcess implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
@GeneratedValue(strategy=GenerationType.TABLE, generator="raf_process")  
	@TableGenerator(name="raf_process", table="openjpaseq", pkColumnName="id", valueColumnName="sequence_value", allocationSize=1)  //flush every 1 insert
	@Column(name="process_id", unique=true, nullable=false)
	private Long processId;

	@Column(name="bpm_process_id", nullable=false, length=1000)
	private String bpmProcessId;

	@Column(name="bpm_process_name", nullable=false, length=1000)
	private String bpmProcessName;

	//bi-directional many-to-one association to RafProcessInstance
	@OneToMany(mappedBy="rafProcess")
	private List<RafProcessInstance> rafProcessInstances;

    public RafProcess() {
    }

	public Long getProcessId() {
		return this.processId;
	}

	public void setProcessId(Long processId) {
		this.processId = processId;
	}

	public String getBpmProcessId() {
		return this.bpmProcessId;
	}

	public void setBpmProcessId(String bpmProcessId) {
		this.bpmProcessId = bpmProcessId;
	}

	public String getBpmProcessName() {
		return this.bpmProcessName;
	}

	public void setBpmProcessName(String bpmProcessName) {
		this.bpmProcessName = bpmProcessName;
	}

	public List<RafProcessInstance> getRafProcessInstances() {
		return this.rafProcessInstances;
	}

	public void setRafProcessInstances(List<RafProcessInstance> rafProcessInstances) {
		this.rafProcessInstances = rafProcessInstances;
	}
	
}