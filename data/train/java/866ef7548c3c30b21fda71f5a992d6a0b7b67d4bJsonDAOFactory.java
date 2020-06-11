package xdl.wxk.financing.json.factory;


import xdl.wxk.financing.json.JsonAccountManage;
import xdl.wxk.financing.json.JsonOperatorManage;
import xdl.wxk.financing.json.proxy.JsonAccountManageProxy;
import xdl.wxk.financing.json.proxy.JsonOpreatorManageProxy;

public class JsonDAOFactory {
	static public JsonOperatorManage getJsonOperatorManageDAOInstance(){
		return new JsonOpreatorManageProxy();
	}
	static public JsonAccountManage getJsonAccountManageDAOInstance(){
		return new JsonAccountManageProxy();
	}
}
