package com.qagwaai.starmalaccamax.client.core.mvp;

import com.qagwaai.starmalaccamax.shared.model.UserDTO;
import com.smartgwt.client.widgets.events.ClickHandler;

public interface LoginBarView extends View {

    void setUser(final UserDTO user, final String logoutUrl);

    void setLogin(final String url);

    void addCommunicationsButtonClickHandler(ClickHandler handler);

    void setCommunicationsButtonDisabled(boolean disabled);

    void addFleetSummaryButtonClickHandler(ClickHandler handler);

    void setFleetSummaryButtonDisabled(boolean disabled);

    void addLogoutButtonClickHandler(ClickHandler handler);

    void setLogoutButtonDisabled(boolean disabled);

    void addOpportunitiesButtonClickHandler(ClickHandler handler);

    void setOpportunitiesButtonDisabled(boolean disabled);

    void addProfileButtonClickHandler(ClickHandler handler);

    void setProfileButtonDisabled(boolean disabled);

    void addAboutButtonClickHandler(ClickHandler handler);

    void addNewCaptainWizardButtonClickHandler(com.smartgwt.client.widgets.menu.events.ClickHandler handler);

    void addAddSuperCaptainButtonClickHandler(com.smartgwt.client.widgets.menu.events.ClickHandler handler);

    void addPrimerButtonClickHandler(ClickHandler handler);

    void addSetUserAsNewMenuClickHandler(com.smartgwt.client.widgets.menu.events.ClickHandler handler);

    void addViewSolarSystem1049MenuClickHandler(com.smartgwt.client.widgets.menu.events.ClickHandler handler);

    void addRemoveAllUsersMenuClickHandler(com.smartgwt.client.widgets.menu.events.ClickHandler handler);

    void addRemoveAllSunsMenuClickHandler(com.smartgwt.client.widgets.menu.events.ClickHandler handler);

    void addRemoveAllSolarSystemsMenuClickHandler(com.smartgwt.client.widgets.menu.events.ClickHandler handler);

    void addRemoveAllShipTypesMenuClickHandler(com.smartgwt.client.widgets.menu.events.ClickHandler handler);

    void addRemoveAllShipsMenuClickHandler(com.smartgwt.client.widgets.menu.events.ClickHandler handler);

    void addRemoveAllPlanetsMenuClickHandler(com.smartgwt.client.widgets.menu.events.ClickHandler handler);

    void addRemoveAllMarketsMenuClickHandler(com.smartgwt.client.widgets.menu.events.ClickHandler handler);

    void addRemoveAllJumpGatesMenuClickHandler(com.smartgwt.client.widgets.menu.events.ClickHandler handler);

    void addRemoveAllJobsMenuClickHandler(com.smartgwt.client.widgets.menu.events.ClickHandler handler);

    void addRemoveAllGameEventsMenuClickHandler(com.smartgwt.client.widgets.menu.events.ClickHandler handler);

    void addRemoveAllClosestMenuClickHandler(com.smartgwt.client.widgets.menu.events.ClickHandler handler);

    void addRemoveAllCaptainsMenuClickHandler(com.smartgwt.client.widgets.menu.events.ClickHandler handler);

    void addManageUsersMenuClickHandler(com.smartgwt.client.widgets.menu.events.ClickHandler handler);

    void addManageSunsMenuClickHandler(com.smartgwt.client.widgets.menu.events.ClickHandler handler);

    void addManageSolarSystemsMenuClickHandler(com.smartgwt.client.widgets.menu.events.ClickHandler handler);

    void addManageShipTypesMenuClickHandler(com.smartgwt.client.widgets.menu.events.ClickHandler handler);

    void addManageShipsMenuClickHandler(com.smartgwt.client.widgets.menu.events.ClickHandler handler);

    void addManagePlanetsMenuClickHandler(com.smartgwt.client.widgets.menu.events.ClickHandler handler);

    void addManageMarketsMenuClickHandler(com.smartgwt.client.widgets.menu.events.ClickHandler handler);

    void addManageJumpGatesMenuClickHandler(com.smartgwt.client.widgets.menu.events.ClickHandler handler);

    void addManageJobsMenuClickHandler(com.smartgwt.client.widgets.menu.events.ClickHandler handler);

    void addManageGameEventsMenuClickHandler(com.smartgwt.client.widgets.menu.events.ClickHandler handler);

    void addManageClosestMenuClickHandler(com.smartgwt.client.widgets.menu.events.ClickHandler handler);

    void addManageCaptainsMenuClickHandler(com.smartgwt.client.widgets.menu.events.ClickHandler handler);
}