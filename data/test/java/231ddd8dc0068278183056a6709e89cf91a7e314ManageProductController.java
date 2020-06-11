package controller;

import model.ManageProductModel;
import view.ManageProductView;

public class ManageProductController {
	
	private ManageProductModel manageProductModel;
	private ManageProductView manageProductView;
	
	public void addModel(ManageProductModel model) {
		manageProductModel = model;
	}
	
	public void addView(ManageProductView view) {
		manageProductView = view;
	}

	public ManageProductController(ManageProductModel model, ManageProductView view) {
		manageProductModel = model;
		manageProductView = view;
	}
	
	public void init(String filter, boolean activeOnly) {
		manageProductModel.update(filter, activeOnly);
		manageProductView.show();
	}
	
	public void update(String filter, boolean activeOnly) {
		manageProductModel.update(filter, activeOnly);
	}
	
}
