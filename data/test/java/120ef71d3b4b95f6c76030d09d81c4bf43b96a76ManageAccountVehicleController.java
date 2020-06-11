package controller;

import model.ManageAccountVehicleModel;
import view.ManageAccountVehicleView;

/**
 * 
 ******************************************************************************
 * Modification log of ManageAccountVehicleController.java                                            
 ******************************************************************************
 * Date     User         Description                                           
 * -------- ------------ ------------------------------------------------------
 * 05-12-17 romerori     Initial creation & add MVC pattern.
 ******************************************************************************
 *
 */
public class ManageAccountVehicleController {
	
	private ManageAccountVehicleModel manageAccountVehicleModel;
	private ManageAccountVehicleView manageAccountVehicleView;
	
	public void addModel(ManageAccountVehicleModel manageAccountVehicleModel) {
		this.manageAccountVehicleModel = manageAccountVehicleModel;
	}
	
	public void addView(ManageAccountVehicleView manageAccountVehicleView) {
		this.manageAccountVehicleView = manageAccountVehicleView;
	}
	
	public void init(String filter, boolean activeOnly) {
		updateModel(filter.toUpperCase(), activeOnly);
		manageAccountVehicleView.showView();
	}
	
	public void updateModel(String filter, boolean activeOnly) {
		manageAccountVehicleModel.update(filter.toUpperCase(), activeOnly);
	}

}