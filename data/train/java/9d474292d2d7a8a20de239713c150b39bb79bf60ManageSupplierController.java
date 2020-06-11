package controller;

import model.ManageSupplierModel;
import view.ManageSupplierView;

public class ManageSupplierController {
	
	private ManageSupplierModel manageSupplierModel;
	private ManageSupplierView manageSupplierView;
	
	public ManageSupplierController(ManageSupplierModel model, ManageSupplierView view) {
		manageSupplierModel = model;
		manageSupplierView = view;
	}
	
	public void addModel(ManageSupplierModel model) {
		manageSupplierModel = model;
	}
	
	public void addView(ManageSupplierView view) {
		manageSupplierView = view;
	}
	
	public void init(String filter, boolean activeOnly) {
		manageSupplierModel.update(filter.toUpperCase(), activeOnly);
		manageSupplierView.show();
	}
	
	public void update(String filter, boolean activeOnly) {
		manageSupplierModel.update(filter.toUpperCase(), activeOnly);
	}

}