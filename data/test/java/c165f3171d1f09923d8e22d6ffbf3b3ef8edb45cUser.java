
public class User {
	private int id;
	private String password;
	private boolean manage;
	
	public User(int id, String password, boolean manage)
	{
		this.id = id;
		this.password = password;
		this.manage = manage;
	}
	
	public User(User u)
	{
		
	}

	/** returns id int*/
	public int getId() {
		return id;
	}

	/** sets id*/
	public void setId(int id) {
		this.id = id;
	}

	/**returns password string*/
	public String getPassword() {
		return password;
	}

	/** sets password*/
	public void setPassword(String password) {
		this.password = password;
	}

	/**Returns manager boolean*/
	public boolean isManage() {
		return manage;
	}

	/**sets manager*/
	public void setManage(boolean manage) {
		this.manage = manage;
	}
	
}
