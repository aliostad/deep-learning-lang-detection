package com.target.framework.user;

import com.target.pages.ManageReturnsPage;
import com.target.framework.PageStore;
import com.target.framework.TestSession;

public class ManageReturnsPageUser {

	private PageStore pageStore;

	public ManageReturnsPageUser(PageStore pageStore, TestSession session){
		this.pageStore = pageStore;
	}

	
	private ManageReturnsPage getManageReturnsPage() {
		ManageReturnsPage manageReturnsPage = pageStore.getPage(ManageReturnsPage.class);
		return manageReturnsPage;
	}
	
	public void canVerifyUserLandsOnManageReturnsPageSuccesfully(){
		getManageReturnsPage().verifyUserLandsOnManageReturnsPageSuccesfully();
		
	}
	
	
}
