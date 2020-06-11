package be.ac.fundp.precise.dataManagment.hibernate.daos;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;

/**
 * The Class BindingProcess.
 */
@Entity(name="BindingProcess")
public class BindingProcess {

	/** The process real id. */
	@Id
	@GeneratedValue
	private int processRealId;

	/** The process instance. */
	@OneToOne
	@JoinColumn(name="process_instance", nullable=false)
	private ProcessInstance processInstance;

	/** The role. */
	@OneToOne
	@JoinColumn(name="bond_role", nullable=false)
	private Role role;

	/** The user. */
	@OneToOne
	@JoinColumn(name="bond_user", nullable=false)
	private User user;
	
	/** The registred process. */
	@OneToOne
	@JoinColumn(name="registred_process", nullable=false)
	private RegistredProcess registredProcess;

	/**
	 * Gets the process instance.
	 *
	 * @return the process instance
	 */
	public ProcessInstance getProcessInstance() {
		return processInstance;
	}

	/**
	 * Sets the process instance.
	 *
	 * @param process the new process instance
	 */
	public void setProcessInstance(ProcessInstance process) {
		this.processInstance = process;
	}

	/**
	 * Gets the role.
	 *
	 * @return the role
	 */
	public Role getRole() {
		return role;
	}

	/**
	 * Sets the role.
	 *
	 * @param role the new role
	 */
	public void setRole(Role role) {
		this.role = role;
	}

	/**
	 * Gets the user.
	 *
	 * @return the user
	 */
	public User getUser() {
		return user;
	}

	/**
	 * Sets the user.
	 *
	 * @param user the new user
	 */
	public void setUser(User user) {
		this.user = user;
	}

	/**
	 * Gets the process real id.
	 *
	 * @return the process real id
	 */
	public int getProcessRealId() {
		return processRealId;
	}

	/**
	 * Sets the process real id.
	 *
	 * @param processRealId the new process real id
	 */
	public void setProcessRealId(int processRealId) {
		this.processRealId = processRealId;
	}

	/**
	 * Gets the registred process.
	 *
	 * @return the registred process
	 */
	public RegistredProcess getRegistredProcess() {
		return registredProcess;
	}

	/**
	 * Sets the registred process.
	 *
	 * @param registredProcess the new registred process
	 */
	public void setRegistredProcess(RegistredProcess registredProcess) {
		this.registredProcess = registredProcess;
	}
}
