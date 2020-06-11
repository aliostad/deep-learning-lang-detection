package controller;

import org.hibernate.HibernateException;

import model.MainModel;
import model.ManageAccountModel;
import model.ManageAccountVehicleModel;
import model.ManagePersonModel;
import model.ManageSubcategoryModel;
import model.ManageVehicleModel;
import util.Constants;
import view.MainView;
import view.ManageAccountVehicleView;
import view.ManageAccountView;
import view.ManagePersonView;
import view.ManageSubcategoryView;
import view.ManageVehicleView;

/**
 * 
 ******************************************************************************
 * Modification log of MainController.java                                            
 ******************************************************************************
 * Date     User         Description                                           
 * -------- ------------ ------------------------------------------------------
 * 05-12-17 romerori     Initial creation.
 ******************************************************************************
 *
 */
public class MainController {
	
	private MainModel mainModel;
	private MainView mainView;

	public void addModel(MainModel mainModel) {
		this.mainModel = mainModel;
	}
	
	public void addView(MainView mainView) {
		this.mainView = mainView;
	}
	
	public void init() {
		mainModel.init();
		mainView.showView();
	}
	
	public void manageSubcategory() {
		try {
			/*
			 * Create Model & View
			 */
			ManageSubcategoryModel manageSubcategoryModel = new ManageSubcategoryModel();
			ManageSubcategoryView manageSubcategoryView = new ManageSubcategoryView(mainView, true);
			/*
			 * Hardwire Model & View
			 */
			manageSubcategoryModel.addObserver(manageSubcategoryView);
			/*
			 * Create Controller and fill it with Model & View
			 */
			ManageSubcategoryController manageSubcategoryController = new ManageSubcategoryController();
			manageSubcategoryController.addModel(manageSubcategoryModel);
			manageSubcategoryController.addView(manageSubcategoryView);
			/*
			 * Add Controller to the View
			 */
			manageSubcategoryView.addController(manageSubcategoryController);
			manageSubcategoryView.init();
		}
		catch(HibernateException ex) {
			if(Constants.TESTING_MODE)
				ex.printStackTrace();
		}
	}
	
	public void managePerson() {
		try {
			ManagePersonModel managePersonModel = new ManagePersonModel();
			ManagePersonView managePersonView = new ManagePersonView(mainView, true);
			managePersonModel.addObserver(managePersonView);
			
			ManagePersonController managePersonController = new ManagePersonController();
			managePersonController.addModel(managePersonModel);
			managePersonController.addView(managePersonView);
			
			managePersonView.addController(managePersonController);
			managePersonView.init();
		}
		catch(HibernateException ex) {
			if(Constants.TESTING_MODE)
				ex.printStackTrace();
		}
	}
	
	public void manageVehicle() {
		try {
			ManageVehicleModel manageVehicleModel = new ManageVehicleModel();
			ManageVehicleView manageVehicleView = new ManageVehicleView(mainView, true);
			manageVehicleModel.addObserver(manageVehicleView);
			
			ManageVehicleController manageVehicleController = new ManageVehicleController();
			manageVehicleController.addModel(manageVehicleModel);
			manageVehicleController.addView(manageVehicleView);
			
			manageVehicleView.addController(manageVehicleController);
			manageVehicleView.init();
		}
		catch(HibernateException ex) {
			if(Constants.TESTING_MODE)
				ex.printStackTrace();
		}
	}
	
	public void manageAccountVehicle() {
		try {
			ManageAccountVehicleModel manageAccountVehicleModel = new ManageAccountVehicleModel();
			ManageAccountVehicleView manageAccountVehicleView = new ManageAccountVehicleView(mainView, true);
			manageAccountVehicleModel.addObserver(manageAccountVehicleView);
			
			ManageAccountVehicleController manageAccountVehicleController = new ManageAccountVehicleController();
			manageAccountVehicleController.addModel(manageAccountVehicleModel);
			manageAccountVehicleController.addView(manageAccountVehicleView);
			
			manageAccountVehicleView.addController(manageAccountVehicleController);
			manageAccountVehicleView.init();
		}
		catch(HibernateException ex) {
			if(Constants.TESTING_MODE)
				ex.printStackTrace();
		}
	}
	
	public void manageAccount() {
		try {
			ManageAccountModel manageAccountModel = new ManageAccountModel();
			ManageAccountView manageAccountView = new ManageAccountView(mainView, true);
			manageAccountModel.addObserver(manageAccountView);
			
			ManageAccountController manageAccountController = new ManageAccountController();
			manageAccountController.addModel(manageAccountModel);
			manageAccountController.addView(manageAccountView);
			
			manageAccountView.addController(manageAccountController);
			manageAccountView.init();
		}
		catch(HibernateException ex) {
			if(Constants.TESTING_MODE)
				ex.printStackTrace();
		}
	}

}
