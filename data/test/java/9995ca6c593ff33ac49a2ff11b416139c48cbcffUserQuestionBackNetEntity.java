package com.android.tonight8.io.org.entity;

import java.util.ArrayList;

import com.android.tonight8.model.organization.OrgQuestionModel;

/**
 * @Description:用户反馈（商家）
 * @author:LiuZhao
 * @Date:2015年3月9日
 */
public class UserQuestionBackNetEntity {

	public ArrayList<OrgQuestionModel> orgManageQuestions;

	public ArrayList<OrgQuestionModel> getOrgManageQuestions() {
		return orgManageQuestions;
	}

	public void setOrgManageQuestions(ArrayList<OrgQuestionModel> orgManageQuestions) {
		this.orgManageQuestions = orgManageQuestions;
	}
}
