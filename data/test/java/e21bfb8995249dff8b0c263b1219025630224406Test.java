package cn.com.dhcc.cgn.it100.main;

import org.json.JSONObject;

import cn.com.dhcc.cgn.it100.pojo.IT100ResourceManageInfo;

public class Test {
	public static void main(String[] args) {
		IT100ResourceManageInfo manageInfo = new IT100ResourceManageInfo();
		//String jsonObj = "{\"Name\":null}";
		String jsonObj = "{\"Name\":\"\"}";
		JSONObject manageJson = new JSONObject(jsonObj);
		//String name = manageJson.getString("Name");
		String name = manageJson.get("Name").toString();
		manageInfo.setName(name);
		System.out.println(manageInfo);
	}
}
