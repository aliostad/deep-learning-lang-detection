package com.ds.dreamstation.dto;

import com.ds.dreamstation.po.Authority;

/**
 * @author phn
 * @date 2015-5-27
 * @email 1016593477@qq.com
 * @TODO
 */
public class AuthorityInfo {
	
	/**
	 * 是否能够发布新闻
	 */
	private String publishNews;
	/**
	 * 能否管理新闻
	 */
	private String manageNews;
	/**
	 * 能否回复留言
	 */
	private String replyMessage;
	/**
	 * 能否管理留言
	 */
	private String manageMessage;
	/**
	 * 能否发布项目
	 */
	private String publishProject;
	/**
	 * 能否管理项目
	 */
	private String manageProject;
	/**
	 * 能够登录
	 */
	private String allowLogin;
	/**
	 * 能否管理成员
	 */
	private String manageMember;

	/**
	 * 能否管理管理员
	 */
	private String manageAdmin;

	public AuthorityInfo() {
		super();
	}

	public AuthorityInfo(Authority authority) {
		super();
		this.setAllowLogin(authority.isaAllowLogin());
		this.setManageAdmin(authority.isaManageAdmin());
		this.setManageMember(authority.isaManageMember());
		this.setManageMessage(authority.isaManageMessage());
		this.setManageNews(authority.isaManageNews());
		this.setManageProject(authority.isaManageProject());
		this.setPublishNews(authority.isaPublishNews());
		this.setPublishProject(authority.isaPublishProject());
		this.setReplyMessage(authority.isaReplyMessage());

	}

	public String getPublishNews() {
		return publishNews;
	}

	public void setPublishNews(boolean publishNews) {
		if(publishNews){
			this.publishNews = "可以添加新闻动态";
		}else{
			this.publishNews = "不可以添加新闻动态";
		}
		
	}

	public String getManageNews() {
		return manageNews;
	}

	public void setManageNews(boolean manageNews) {
		if(manageNews){
			this.manageNews = "具备管理新闻权限";
		}else{
			this.manageNews = "不具备管理新闻权限";
		}
	}

	public String getReplyMessage() {
		return replyMessage;
	}

	public void setReplyMessage(boolean replyMessage) {
		if(replyMessage){
			this.replyMessage = "可以回复留言";
		}else{
			this.replyMessage = "不可以回复留言";
		}
		
	}

	public String getManageMessage() {
		return manageMessage;
	}

	public void setManageMessage(boolean manageMessage) {
		if(manageMessage){
			this.manageMessage = "具备管理留言权限";
		}else{
			this.manageMessage = "不具备管理留言权限";
		}
	}

	public String getPublishProject() {
		return publishProject;
	}

	public void setPublishProject(boolean publishProject) {
		if(publishProject){
			this.publishProject = "可以发布项目";
		}else{
			this.publishProject = "不可以发布项目";
		}
		
	}

	public String getManageProject() {
		return manageProject;
	}

	public void setManageProject(boolean manageProject) {
		if(manageProject){
			this.manageProject="具备管理项目权限";
		}else{
			this.manageProject="不具备管理项目权限";
		}
	}

	public String getAllowLogin() {
		return allowLogin;
	}

	public void setAllowLogin(boolean allowLogin) {
		if(allowLogin){
			this.allowLogin = "可以登录";
		}else{
			this.allowLogin = "禁止登录";
		}
	}

	public String getManageMember() {
		return manageMember;
	}

	public void setManageMember(boolean manageMember) {
		if(manageMember){
			this.manageMember = "普通管理员：可以管理普通用户";
		}else{
			this.manageMember = "无管理普通用户权限";
		}
	}

	public String getManageAdmin() {
		return manageAdmin;
	}

	public void setManageAdmin(boolean manageAdmin) {
		if(manageAdmin){
			this.manageAdmin = "高级管理员：可以管理所有用户，包括普通管理员";
		}else{
			this.manageAdmin = "无管理管理员权限";
		}
	}

}
