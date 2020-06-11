package cn.e21.hbjyhf.service.impl;

import cn.e21.hbjyhf.service.AreaService;
import cn.e21.hbjyhf.service.CompCategoryService;
import cn.e21.hbjyhf.service.DiplomaService;
import cn.e21.hbjyhf.service.InformationService;
import cn.e21.hbjyhf.service.ReplyService;
import cn.e21.hbjyhf.service.SourceService;
import cn.e21.hbjyhf.service.UserService;

public class Factory {
	private static AreaService areaService;
	private static CompCategoryService compCategoryService;
	private static SourceService sourceService;
	private static DiplomaService diplomaService;
	private static InformationService informationService;
	private static ReplyService replyService;
	private static UserService userService;
	static{
		areaService=new AreaServiceImpl();
		compCategoryService=new CompCategoryServiceImpl();
		sourceService = new SourceServiceImpl();
		diplomaService=new DiplomaServiceImpl();
		informationService=new InformationServiceImpl();
		replyService=new ReplyServiceImpl();
		userService=new UserServiceImpl();
	}
	private Factory(){
		
	}
	public static AreaService getAreaService() {
		return areaService;
	}
	public static CompCategoryService getCompCategoryService() {
		return compCategoryService;
	}
	public static SourceService getSourceService() {
		return sourceService;
	}
	public static DiplomaService getDiplomaService() {
		return diplomaService;
	}
	public static InformationService getInformationService() {
		return informationService;
	}
	public static ReplyService getReplyService() {
		return replyService;
	}
	public static UserService getUserService() {
		return userService;
	}
}
