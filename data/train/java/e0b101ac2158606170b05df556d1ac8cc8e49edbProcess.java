package qms.model;
import org.hibernate.validator.constraints.NotEmpty;
public class Process
{
	@NotEmpty
	private String process_id;
	@NotEmpty
	private String process_name;
	@NotEmpty
	private String process_owner;
	
	private String auto_id;

	public Process(String auto_id,String process_id, String process_name, String process_owner) {
		super();
		this.auto_id = auto_id;
		this.process_id = process_id;
		this.process_name = process_name;
		this.process_owner = process_owner;
	}

	public Process() {
		super();
		// TODO Auto-generated constructor stub
	}



	public String getAuto_id() {
		return auto_id;
	}

	public void setAuto_id(String auto_id) {
		this.auto_id = auto_id;
	}

	public String getProcess_id() {
		return process_id;
	}

	public void setProcess_id(String process_id) {
		this.process_id = process_id;
	}

	public String getProcess_name() {
		return process_name;
	}

	public void setProcess_name(String process_name) {
		this.process_name = process_name;
	}

	public String getProcess_owner() {
		return process_owner;
	}

	public void setProcess_owner(String process_owner) {
		this.process_owner = process_owner;
	}
	
	
}