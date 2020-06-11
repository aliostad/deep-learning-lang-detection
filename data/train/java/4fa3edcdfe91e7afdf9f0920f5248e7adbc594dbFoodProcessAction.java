package com.pitaya.bookingnow.action;

import com.opensymphony.xwork2.ActionSupport;
import com.pitaya.bookingnow.model.FoodProcess;
import com.pitaya.bookingnow.service.IFoodProcessService;

public class FoodProcessAction extends ActionSupport{

	private static final long serialVersionUID = -11025061163530110L;
	private IFoodProcessService foodProcessService;
	private FoodProcess foodProcess;
	
	public IFoodProcessService getFoodProcessService() {
		return foodProcessService;
	}
	public void setFoodProcessService(IFoodProcessService foodProcessService) {
		this.foodProcessService = foodProcessService;
	}
	public FoodProcess getFoodProcess() {
		return foodProcess;
	}
	public void setFoodProcess(FoodProcess foodProcess) {
		this.foodProcess = foodProcess;
	}
	
	public String findFoodProcess() {
		if (foodProcess != null) {
			foodProcessService.selectByPrimaryKey(foodProcess.getPid());
			
			return "findSuccess";
		}
		
		return "findFail";
	}
	
	public String addFoodProcess() {
		if (foodProcess != null) {
			foodProcessService.insert(foodProcess);
			
			return "addSuccess";
		}
		
		return "addFail";
	}
	
	public String removeFoodProcess() {
		if (foodProcess != null) {
			foodProcessService.deleteByPrimaryKey(foodProcess.getPid());
			
			return "removeSuccess";
		}
		
		return "removeFail";
	}
	
	public String updateFoodProcess() {
		if (foodProcess != null) {
			foodProcessService.updateByPrimaryKey(foodProcess);
			
			return "updateSuccess";
		}
		
		return "updateFail";
	}
	
	
}
