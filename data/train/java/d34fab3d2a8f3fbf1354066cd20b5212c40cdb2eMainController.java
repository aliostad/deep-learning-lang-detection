package com.tgwy.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MainController {

	@RequestMapping("/mainInfo")
	public String main() {
		return "main";
	}
	
	@RequestMapping("/communitySecurity")
	public String communitySecurity(){
		return "community_security";
	}
	
	@RequestMapping("/socialBoxes")
	public String socialBoxes(){
		return "social_boxes";
	}
	
	@RequestMapping("/informationBoxes")
	public String informationBoxes(){
		return "information_boxes";
	}
	
	
	//住户管理操作栏，跳转
	@RequestMapping("/houseManage")
	public String houseManage(){
		return "house_manage";
	}
	
	@RequestMapping("/ownerManage")
	public String ownerManage(){
		return "owner_manage";
	}
	
	@RequestMapping("/chargeManage")
	public String chargeManage(){
		return "charge_manage";
	}
	
	@RequestMapping("/rentManage")
	public String rentManage(){
		return "rent_manage";
	}
}
