package processmodel;

import java.io.Serializable;

import javax.persistence.*;

import org.hibernate.annotations.GenericGenerator;
import org.hibernate.annotations.Parameter;





import java.util.Date;
import java.util.List;


/**
 * The persistent class for the PROCESS_INSTANCE database table.
 * 
 */
@Entity
@Table(name="PROCESS_INSTANCE")
@NamedQuery(name="ProcessInstance.findAll", query="SELECT p FROM ProcessInstance p")
public class ProcessInstance implements Serializable {
	private static final long serialVersionUID = 1L;
	private long id;
	private String uniqueShortId;
	private String userDefinedId;
	private Date createTime;
	private Date lastTouched;	
	private List<ProcessData> processData;
	private ProcessType processType;
	private List<ProcessInstanceState> processInstanceStates;
	private ProcessInstanceState processInstanceState;	// The current state.
	private List<ProcessAttachment> processAttachments;
	private List<ProcessNote> processNotes;


	public ProcessInstance() {
	}


	@GenericGenerator(name = "generator", strategy = "org.hibernate.id.enhanced.TableGenerator",parameters={@Parameter(name="segment_value",value="ProcessInstance")})
	@Id
	@GeneratedValue(generator="generator")
	public long getId() {
		return this.id;
	}

	public void setId(long id) {
		this.id = id;
	}



	@Column(name="UNIQUE_SHORT_ID")
	public String getUniqueShortId() {
		return this.uniqueShortId;
	}

	public void setUniqueShortId(String uniqueShortId) {
		this.uniqueShortId = uniqueShortId;
	}


	@Column(name="USER_DEFINED_ID")
	public String getUserDefinedId() {
		return this.userDefinedId;
	}

	public void setUserDefinedId(String userDefinedId) {
		this.userDefinedId = userDefinedId;
	}

	@Column(name="LAST_TOUCHED")
	public Date getLastTouched() {
		return lastTouched;
	}


	public void setLastTouched(Date lastTouched) {
		this.lastTouched = lastTouched;
	}


	@Column(name="CREATE_TIME")
	public Date getCreateTime() {
		return createTime;
	}


	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	
	//bi-directional many-to-one association to ProcessType
	@ManyToOne
	@JoinColumn(name="PROCESS_TYPE_ID")
	public ProcessType getProcessType() {
		return this.processType;
	}

	public void setProcessType(ProcessType processType) {
		this.processType = processType;
	}
	

	//bi-directional many-to-one association to ProcessData
	@OneToMany(mappedBy="processInstance")
	public List<ProcessData> getProcessData() {
		return this.processData;
	}

	public void setProcessData(List<ProcessData> processData) {
		this.processData = processData;
	}

	public ProcessData addProcessData(ProcessData processData) {
		getProcessData().add(processData);
		processData.setProcessInstance(this);

		return processData;
	}

	public ProcessData removeProcessData(ProcessData processData) {
		getProcessData().remove(processData);
		processData.setProcessInstance(null);

		return processData;
	}


	//bi-directional many-to-one association to ProcessInstanceState
	@OneToMany(mappedBy="processInstance")
	public List<ProcessInstanceState> getProcessInstanceStates() {
		return this.processInstanceStates;
	}

	public void setProcessInstanceStates(List<ProcessInstanceState> processInstanceStates) {
		this.processInstanceStates = processInstanceStates;
	}

	public ProcessInstanceState addProcessInstanceState(ProcessInstanceState processInstanceState) {
		getProcessInstanceStates().add(processInstanceState);
		processInstanceState.setProcessInstance(this);

		return processInstanceState;
	}

	public ProcessInstanceState removeProcessInstanceState(ProcessInstanceState processInstanceState) {
		getProcessInstanceStates().remove(processInstanceState);
		processInstanceState.setProcessInstance(null);

		return processInstanceState;
	}

	//bi-directional many-to-one association to ProcessInstance
	@ManyToOne
	@JoinColumn(name="PROCESS_CURRENT_STATE_ID",nullable=true)
	public ProcessInstanceState getProcessInstanceState() {
		return processInstanceState;
	}


	public void setProcessInstanceState(ProcessInstanceState processInstanceState) {
		this.processInstanceState = processInstanceState;
	}


	
	//bi-directional many-to-one association to ProcessAttachment
	@OneToMany(mappedBy="processInstance")
	public List<ProcessAttachment> getProcessAttachments() {
		return this.processAttachments;
	}

	public void setProcessAttachments(List<ProcessAttachment> processAttachments) {
		this.processAttachments = processAttachments;
	}

	public ProcessAttachment addProcessAttachment(ProcessAttachment processAttachment) {
		getProcessAttachments().add(processAttachment);
		processAttachment.setProcessInstance(this);

		return processAttachment;
	}

	public ProcessAttachment removeProcessAttachment(ProcessAttachment processAttachment) {
		getProcessAttachments().remove(processAttachment);
		processAttachment.setProcessInstance(null);

		return processAttachment;
	}


	//bi-directional many-to-one association to ProcessNote
	@OneToMany(mappedBy="processInstance")
	public List<ProcessNote> getProcessNotes() {
		return this.processNotes;
	}

	public void setProcessNotes(List<ProcessNote> processNotes) {
		this.processNotes = processNotes;
	}

	public ProcessNote addProcessNote(ProcessNote processNote) {
		getProcessNotes().add(processNote);
		processNote.setProcessInstance(this);

		return processNote;
	}

	public ProcessNote removeProcessNote(ProcessNote processNote) {
		getProcessNotes().remove(processNote);
		processNote.setProcessInstance(null);

		return processNote;
	}
	
}