package com.xplan.apps.aplan.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * 
 * XpManageUser entity. @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "xp_manage_user", catalog = "xplan")
public class XpManageUser implements java.io.Serializable {

	// Fields

	private Integer xpManageUserId;
	private String xpManageUserName;
	private String xpManageUserPassword;
	private String xpManageUserSex;
	private String xpManageUserPhone;
	private String xpManageUserEmail;

	// Constructors

	/** default constructor */
	public XpManageUser() {
	}

	/** full constructor */
	public XpManageUser(String xpManageUserName, String xpManageUserPassword,
			String xpManageUserSex, String xpManageUserPhone,
			String xpManageUserEmail) {
		this.xpManageUserName = xpManageUserName;
		this.xpManageUserPassword = xpManageUserPassword;
		this.xpManageUserSex = xpManageUserSex;
		this.xpManageUserPhone = xpManageUserPhone;
		this.xpManageUserEmail = xpManageUserEmail;
	}

	// Property accessors
	@Id
	@GeneratedValue
	@Column(name = "xp_manage_user_id", unique = true, nullable = false)
	public Integer getXpManageUserId() {
		return this.xpManageUserId;
	}

	public void setXpManageUserId(Integer xpManageUserId) {
		this.xpManageUserId = xpManageUserId;
	}

	@Column(name = "xp_manage_user_name", nullable = false, length = 20)
	public String getXpManageUserName() {
		return this.xpManageUserName;
	}

	public void setXpManageUserName(String xpManageUserName) {
		this.xpManageUserName = xpManageUserName;
	}

	@Column(name = "xp_manage_user_password", nullable = false, length = 20)
	public String getXpManageUserPassword() {
		return this.xpManageUserPassword;
	}

	public void setXpManageUserPassword(String xpManageUserPassword) {
		this.xpManageUserPassword = xpManageUserPassword;
	}

	@Column(name = "xp_manage_user_sex", nullable = false, length = 5)
	public String getXpManageUserSex() {
		return this.xpManageUserSex;
	}

	public void setXpManageUserSex(String xpManageUserSex) {
		this.xpManageUserSex = xpManageUserSex;
	}

	@Column(name = "xp_manage_user_phone", nullable = false, length = 11)
	public String getXpManageUserPhone() {
		return this.xpManageUserPhone;
	}

	public void setXpManageUserPhone(String xpManageUserPhone) {
		this.xpManageUserPhone = xpManageUserPhone;
	}

	@Column(name = "xp_manage_user_email", nullable = false, length = 50)
	public String getXpManageUserEmail() {
		return this.xpManageUserEmail;
	}

	public void setXpManageUserEmail(String xpManageUserEmail) {
		this.xpManageUserEmail = xpManageUserEmail;
	}

}