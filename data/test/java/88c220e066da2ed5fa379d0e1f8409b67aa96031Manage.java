package hfdb.entity;

public class Manage {
	private int manageId;
	private String manageName;
	private String managePwd;
	
	public int getManageId() {
		return manageId;
	}
	public void setManageId(int manageId) {
		this.manageId = manageId;
	}
	public String getManageName() {
		return manageName;
	}
	public void setManageName(String manageName) {
		this.manageName = manageName;
	}
	public String getManagePwd() {
		return managePwd;
	}
	public void setManagePwd(String managePwd) {
		this.managePwd = managePwd;
	}
	public Manage() {
		super();
		// TODO Auto-generated constructor stub
	}
	public Manage(int manageId, String manageName, String managePwd) {
		super();
		this.manageId = manageId;
		this.manageName = manageName;
		this.managePwd = managePwd;
	}
	@Override
	public String toString() {
		return "Manage [manageId=" + manageId + ", manageName=" + manageName
				+ ", managePwd=" + managePwd + "]";
	}
	
	
}
