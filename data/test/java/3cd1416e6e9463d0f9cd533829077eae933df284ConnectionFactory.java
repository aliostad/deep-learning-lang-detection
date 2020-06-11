package com.finallygo.db.conn;

import java.util.HashMap;
import java.util.Map;

public class ConnectionFactory {
	
	private static Map connManageCache=new HashMap();
	
	public static IConnectionManager getConnManage(){
		String manageName="ConnectionManager";
		IConnectionManager connManage=(IConnectionManager) connManageCache.get(manageName);
		if(connManage!=null){
			return connManage;
		}
		String className=IConnectionManager.rb.getString(manageName);
		try {
			Class clazz=Class.forName(className);
			connManage=(IConnectionManager) clazz.newInstance();
			connManageCache.put(manageName, connManage);
			return connManage;
		} catch (Exception e) {
			throw new RuntimeException("根据配置文件得到连接管理器出现异常!",e);
		}
		
	}
}
