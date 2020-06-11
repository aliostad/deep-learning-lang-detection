package spring.domain;

import java.util.List;


public class QuestionManageList {
	private List<QuestionManage> questManageList;
	private int curatingCode;

	public int getCuratingCode() {
		return curatingCode;
	}

	public void setCuratingCode(int curatingCode) {
		this.curatingCode = curatingCode;
	}

	public List<QuestionManage> getQuestManageList() {
		return questManageList;
	}

	public void setQuestManageList(List<QuestionManage> questManageList) {
		this.questManageList = questManageList;
	}

}
