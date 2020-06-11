package com.ibm.erp.action;

import java.util.List;

import org.apache.struts2.ServletActionContext;
import com.ibm.erp.business.IManageBusiness;
import com.ibm.manage.value.ManageValue;
import com.opensymphony.xwork2.ActionSupport;

public class Manage extends ActionSupport{
		private String id;
		private String password;
		private IManageBusiness ib=null;
		public String getId() {
			return id;
		}
		public void setId(String id) {
			this.id = id;
		}

		public String getPassword() {
			return password;
		}
		public void setPassword(String password) {
			this.password = password;
		}
		
		public IManageBusiness getIb() {
			return ib;
		}
		public void setIb(IManageBusiness ib) {
			this.ib = ib;
		}
		public String toLogin() throws Exception{
			//跳转tologin
			return "toLogin";
			
		}
		
		public String loginManage() throws Exception{
			if(ib.loginManage(getId(), getPassword())){
				//判断权限
				ManageValue manage = (ManageValue) ServletActionContext.getServletContext().getAttribute("mv");
				if(manage.getPosition().equals("物业公司管理员"))
			    return "ManageA";
				if(manage.getPosition().equals("物业财务管理员"))
				return "ManageB";
				if(manage.getPosition().equals("物业公司经理"))
				return "ManageC";
				else
				return "false";
			}
			else
			return "false";
	}
		public String ShowManage() throws Exception{
		    List<ManageValue> manage = ib.showManage();
		    for(ManageValue mv:manage){
		    	System.out.println(""+mv.getName());
		    }
		    System.out.println();
		    //保存管理员到界面
		    ServletActionContext.getServletContext().setAttribute("manage",manage);
			return "ShowManage";		
		}
		
	}