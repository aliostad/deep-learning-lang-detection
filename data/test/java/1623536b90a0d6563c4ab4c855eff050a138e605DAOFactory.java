package xdl.wxk.financing.dao.factory;

import xdl.wxk.financing.dao.AccountManageDAO;
import xdl.wxk.financing.dao.OperatorManageDAO;
import xdl.wxk.financing.dao.PageInfoDAO;
import xdl.wxk.financing.dao.proxy.AccountManageDAOProxy;
import xdl.wxk.financing.dao.proxy.OperatorManageDAOProxy;
import xdl.wxk.financing.dao.proxy.PageInfoDAOProxy;

public class DAOFactory {
	static public OperatorManageDAO getOperatorManageDAOInstance(){
		return new OperatorManageDAOProxy();
	}
	static public AccountManageDAO getAccountManageDAOInstance(){
		return new AccountManageDAOProxy();
	}
	static public PageInfoDAO getOperatorPageInfoDAOInstance(){
		return new PageInfoDAOProxy();
	}
}
