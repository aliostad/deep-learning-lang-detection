package processmodel;

import java.io.Serializable;
import javax.persistence.*;

import org.hibernate.annotations.GenericGenerator;
import org.hibernate.annotations.Parameter;
import java.util.List;


/**
 * The persistent class for the PROCESS_TYPE database table.
 * 
 */
@Entity
@Table(name="PROCESS_TYPE")
@NamedQuery(name="ProcessType.findAll", query="SELECT p FROM ProcessType p")
public class ProcessType implements Serializable {
	private static final long serialVersionUID = 1L;
	private long id;
	private String description;
	private String name;
	private String publishStatus;
	private boolean deployed;
	private BlobData iconData;
	private List<ProcessInstance> processInstances;
	private List<ProcessTypeData> processTypeData;
	private List<ProcessTypeState> processTypeStates;

	public ProcessType() {
	}


	@GenericGenerator(name = "generator", strategy = "org.hibernate.id.enhanced.TableGenerator",parameters={@Parameter(name="segment_value",value="ProcessType")})
	@Id
	@GeneratedValue(generator="generator")
	public long getId() {
		return this.id;
	}

	public void setId(long id) {
		this.id = id;
	}


	public String getDescription() {
		return this.description;
	}

	public void setDescription(String description) {
		this.description = description;
	}


	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}


	@Column(name="PUBLISH_STATUS")
	public String getPublishStatus() {
		return this.publishStatus;
	}

	public void setPublishStatus(String publishStatus) {
		this.publishStatus = publishStatus;
	}
	
	
	public boolean isDeployed() {
		return deployed;
	}


	public void setDeployed(boolean deployed) {
		this.deployed = deployed;
	}
	

	//bi-directional many-to-one association to BlobData
	@ManyToOne
	@JoinColumn(name="ICON_ID")
	public BlobData getIconData() {
		return this.iconData;
	}

	public void setIconData(BlobData iconData) {
		this.iconData = iconData;
	}
	
	//bi-directional many-to-one association to ProcessInstance
	@OneToMany(mappedBy="processType")
	public List<ProcessInstance> getProcessInstances() {
		return this.processInstances;
	}

	public void setProcessInstances(List<ProcessInstance> processInstances) {
		this.processInstances = processInstances;
	}

	public ProcessInstance addProcessInstance(ProcessInstance processInstance) {
		getProcessInstances().add(processInstance);
		processInstance.setProcessType(this);

		return processInstance;
	}

	public ProcessInstance removeProcessInstance(ProcessInstance processInstance) {
		getProcessInstances().remove(processInstance);
		processInstance.setProcessType(null);

		return processInstance;
	}


	//bi-directional many-to-one association to ProcessTypeData
	@OneToMany(mappedBy="processType")
	public List<ProcessTypeData> getProcessTypeData() {
		return this.processTypeData;
	}

	public void setProcessTypeData(List<ProcessTypeData> processTypeData) {
		this.processTypeData = processTypeData;
	}

	public ProcessTypeData addProcessTypeData(ProcessTypeData processTypeData) {
		getProcessTypeData().add(processTypeData);
		processTypeData.setProcessType(this);

		return processTypeData;
	}

	public ProcessTypeData removeProcessTypeData(ProcessTypeData processTypeData) {
		getProcessTypeData().remove(processTypeData);
		processTypeData.setProcessType(null);

		return processTypeData;
	}


	//bi-directional many-to-one association to ProcessTypeState
	@OneToMany(mappedBy="processType")
	public List<ProcessTypeState> getProcessTypeStates() {
		return this.processTypeStates;
	}

	public void setProcessTypeStates(List<ProcessTypeState> processTypeStates) {
		this.processTypeStates = processTypeStates;
	}

	public ProcessTypeState addProcessTypeState(ProcessTypeState processTypeState) {
		getProcessTypeStates().add(processTypeState);
		processTypeState.setProcessType(this);

		return processTypeState;
	}

	public ProcessTypeState removeProcessTypeState(ProcessTypeState processTypeState) {
		getProcessTypeStates().remove(processTypeState);
		processTypeState.setProcessType(null);

		return processTypeState;
	}



}