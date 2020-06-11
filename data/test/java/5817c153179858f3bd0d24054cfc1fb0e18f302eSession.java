package org.psystems.dicom.browser.client.proxy;

import java.io.Serializable;

/**
 * @author dima_d
 * 
 *         Сессионный объект
 */
public class Session implements Serializable{


	private static final long serialVersionUID = -6624806493304305239L;
	
	// ManufacturerModelName 00081090
	String studyManagePanel_ManufacturerModelName = null;
	// Modality 00080060
	String studyManagePanel_Modality = null;

	public String getStudyManagePanel_ManufacturerModelName() {
		return studyManagePanel_ManufacturerModelName;
	}

	public void setStudyManagePanel_ManufacturerModelName(
			String studyManagePanelManufacturerModelName) {
		studyManagePanel_ManufacturerModelName = studyManagePanelManufacturerModelName;
	}

	public String getStudyManagePanel_Modality() {
		return studyManagePanel_Modality;
	}

	public void setStudyManagePanel_Modality(String studyManagePanelModality) {
		studyManagePanel_Modality = studyManagePanelModality;
	}

}
