package cn.blog.model.usergroup;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;



public class UserGroup {
	private int groupId;//组ID
	private String groupName;// 组名称
	private String groupInfo; // 组描述
	private boolean manageArticle = false; // 能否管理文章
	private boolean manageComment = false; // 能否管理评论
	private boolean manageGroup = false; // 能否管理用户组
	private boolean manageUser = false; // 能否管理会员
	private Date sysDate = new Date(); //（系统日期）
	
	public int getGroupId() {
		return groupId;
	}
	public void setGroupId(int groupId) {
		this.groupId = groupId;
	}
	public String getGroupName() {
		return groupName;
	}
	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}
	public String getGroupInfo() {
		return groupInfo;
	}
	public void setGroupInfo(String groupInfo) {
		this.groupInfo = groupInfo;
	}
	public boolean isManageArticle() {
		return manageArticle;
	}
	public void setManageArticle(boolean manageArticle) {
		this.manageArticle = manageArticle;
	}
	public boolean isManageComment() {
		return manageComment;
	}
	public void setManageComment(boolean manageComment) {
		this.manageComment = manageComment;
	}
	public boolean isManageGroup() {
		return manageGroup;
	}
	public void setManageGroup(boolean manageGroup) {
		this.manageGroup = manageGroup;
	}
	public boolean isManageUser() {
		return manageUser;
	}
	public void setManageUser(boolean manageUser) {
		this.manageUser = manageUser;
	}
	public Date getSysDate() {
		return sysDate;
	}
	public void setSysDate(Date sysDate) {
		this.sysDate = sysDate;
	}
	
	

}
