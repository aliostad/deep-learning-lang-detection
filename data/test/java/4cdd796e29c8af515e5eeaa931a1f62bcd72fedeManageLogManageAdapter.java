package org.xhome.xauth.core.listener;

import org.xhome.xauth.ManageLog;
import org.xhome.xauth.User;

/**
 * @project xauth-core
 * @author jhat
 * @email cpf624@126.com
 * @date Aug 10, 20139:10:12 PM
 * @description 
 */
public class ManageLogManageAdapter implements ManageLogManageListener {

	public boolean beforeManageLogManage(User oper, short action, ManageLog manageLog, Object ...args) {
		return true;
	}
	
	public void afterManageLogManage(User oper, short action, short result, ManageLog manageLog, Object ...args) {}
	
}
