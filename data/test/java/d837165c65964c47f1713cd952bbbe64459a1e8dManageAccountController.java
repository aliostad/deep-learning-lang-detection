package controller;

import org.hibernate.HibernateException;

import util.Constants;
import view.ManageAccountFeeView;
import view.ManageAccountView;
import view.component.MyOptionDialog;
import model.ManageAccountFeeModel;
import model.ManageAccountModel;

public class ManageAccountController {

	private ManageAccountModel manageAccountModel;
	private ManageAccountView manageAccountView;
	
	public void addModel(ManageAccountModel manageAccountModel) {
		this.manageAccountModel = manageAccountModel;
	}
	
	public void addView(ManageAccountView manageAccountView) {
		this.manageAccountView = manageAccountView;
	}
	
	public void init(String filter, boolean activeOnly) {
		manageAccountModel.update(filter.toUpperCase(), activeOnly);
		manageAccountView.showView();
	}
	
	public void updateModel(String filter, boolean activeOnly) {
		manageAccountModel.update(filter.toUpperCase(), activeOnly);
	}
	
	public void manageAccountFee(String valueAt, String filter, boolean activeOnly) {
		Integer identifier = Integer.parseInt(valueAt);
		if(manageAccountModel.setAccount(identifier)) {
			try {
				ManageAccountFeeModel manageAccountFeeModel = new ManageAccountFeeModel(manageAccountModel.getAccount());
				ManageAccountFeeView manageAccountFeeView = new ManageAccountFeeView(manageAccountView, true);
				manageAccountFeeModel.addObserver(manageAccountFeeView);
				
				ManageAccountFeeController manageAccountFeeController = new ManageAccountFeeController();
				manageAccountFeeController.addModel(manageAccountFeeModel);
				manageAccountFeeController.addView(manageAccountFeeView);
				
				manageAccountFeeView.addController(manageAccountFeeController);
				manageAccountFeeView.init();
			}
			catch(HibernateException ex) {
				if(Constants.TESTING_MODE)
					ex.printStackTrace();
				else
					MyOptionDialog.showErrorMessage(manageAccountView, Constants.HIBERNATE_ERROR_MESSAGE);
			}
			finally {
				manageAccountModel.update(filter, activeOnly);
			}
		}
	}
	
}
