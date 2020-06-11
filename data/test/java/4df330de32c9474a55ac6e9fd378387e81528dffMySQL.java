package unknown.website;

import unknown.framework.module.database.Instance;

/**
 * MySQL数据库
 */
public final class MySQL {
	public final static String MANAGE_INSTANCE_NAME = "MySQL.ManageInstance";

	private static Instance manageInstance;

	/**
	 * 管理模块实例
	 * 
	 * @return 管理模块实例
	 */
	public static Instance getManageInstance() {
		return manageInstance;
	}

	public static void setManageInstance(Instance manageInstance) {
		MySQL.manageInstance = manageInstance;
	}
}
