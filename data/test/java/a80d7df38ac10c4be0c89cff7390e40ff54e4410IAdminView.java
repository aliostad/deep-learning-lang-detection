package com.infoklinik.rsvp.client.admin.presenter.interfaces;

import com.google.gwt.event.dom.client.ClickHandler;
import com.google.gwt.user.client.ui.IsWidget;
import com.google.gwt.user.client.ui.Widget;
import com.mvp4g.client.view.LazyView;

public interface IAdminView  extends LazyView, IsWidget {
	
	Widget asWidget();
	
	void setInstitutionLinkClickHandler(ClickHandler handler);
	
	void setDoctorLinkClickHandler(ClickHandler handler);
	
	void setUserProfileLinkClickHandler(ClickHandler handler);
	
	void setServiceTypeLinkClickHandler(ClickHandler handler);
	
	void setInsuranceLinkClickHandler(ClickHandler handler);
	
	void setCityLinkClickHandler(ClickHandler handler);
	
	void setRegionLinkClickHandler(ClickHandler handler);
	
	void setStreetLinkClickHandler(ClickHandler handler);
	
	void setLogoutLinkClickHandler(ClickHandler handler);
}
