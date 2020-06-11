package com.target.framework.user;

import com.target.pages.ManageSubscriptionsPage;
import com.target.framework.PageStore;
import com.target.framework.TestSession;

public class ManageSubcriptionsPageUser {

	private PageStore pageStore;

	public ManageSubcriptionsPageUser(PageStore pageStore, TestSession session){
		this.pageStore = pageStore;
	}

	
	private ManageSubscriptionsPage getManageSubcriptionsPage() {
		ManageSubscriptionsPage manageSubscriptionsPage = pageStore.getPage(ManageSubscriptionsPage.class);
		return manageSubscriptionsPage;
	}
	
	public void canVerifyUserLandsOnManageSubscriptionPageSuccesfully(){
		getManageSubcriptionsPage().verifyUserLandsOnManageSubscriptionsPageSuccesfully();
		
	}

}
