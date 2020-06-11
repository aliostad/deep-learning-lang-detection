package controller;

import model.ManageCustomerModel;
import view.ManageCustomerView;

public class ManageCustomerController {
	
	private ManageCustomerModel manageCustomerModel;
	private ManageCustomerView manageCustomerView;
	
	public ManageCustomerController(ManageCustomerModel model, ManageCustomerView view) {
		manageCustomerModel = model;
		manageCustomerView = view;
	}
	
	public void addModel(ManageCustomerModel model) {
		manageCustomerModel = model;
	}
	
	public void addView(ManageCustomerView view) {
		manageCustomerView = view;
	}
	
	public void init(String filter, boolean activeOnly) {
		manageCustomerModel.update(filter, activeOnly);
		manageCustomerView.show();
	}
	
	public void update(String filter, boolean activeOnly) {
		manageCustomerModel.update(filter, activeOnly);
	}

}
