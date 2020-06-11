package com.pitaya.bookingnow.action;


import org.junit.Before;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.pitaya.bookingnow.model.FoodProcess;

public class TestFoodProcessAction {
	ApplicationContext ctx = null;
	
	@Before
	public void init() {
		ctx = new ClassPathXmlApplicationContext("classpath*:/applicationContext.xml");
	}
	
	@Test
	public void testAddFoodProcess() {
		FoodProcessAction foodProcessAction = (FoodProcessAction) ctx.getBean("foodProcessAction");
		FoodProcess foodProcess = new FoodProcess();
		foodProcess.setPid(1);
		foodProcess.setFavourite(4);
		foodProcess.setFood_id(1);
		foodProcess.setOrder_id(1);
		foodProcess.setProcessStatus(3);
		foodProcess.setRemark("一般般");
		
		foodProcessAction.setFoodProcess(foodProcess);
		
		
		String result  = foodProcessAction.addFoodProcess();
		System.out.println("result:" + result);
	}
	
	@Test
	public void testFindFoodProcess() {
		FoodProcessAction foodProcessAction = (FoodProcessAction) ctx.getBean("foodProcessAction");
		FoodProcess foodProcess = new FoodProcess();
		foodProcess.setPid(1);
		
		foodProcessAction.setFoodProcess(foodProcess);
		
		
		String result  = foodProcessAction.findFoodProcess();
		System.out.println("result:" + result);
	}
	
	@Test
	public void testUpdateFoodProcess() {
		FoodProcessAction foodProcessAction = (FoodProcessAction) ctx.getBean("foodProcessAction");
		FoodProcess foodProcess = new FoodProcess();
		foodProcess.setPid(1);
		
		foodProcessAction.setFoodProcess(foodProcess);
		
		
		String result  = foodProcessAction.updateFoodProcess();
		System.out.println("result:" + result);
	}
	
	@Test
	public void testRemoveFoodProcess() {
		FoodProcessAction foodProcessAction = (FoodProcessAction) ctx.getBean("foodProcessAction");
		FoodProcess foodProcess = new FoodProcess();
		foodProcess.setPid(1);
		
		foodProcessAction.setFoodProcess(foodProcess);
		
		
		String result  = foodProcessAction.removeFoodProcess();
		System.out.println("result:" + result);
	}

}
