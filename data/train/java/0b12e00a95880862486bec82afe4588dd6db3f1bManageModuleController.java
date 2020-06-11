package com.community.app.module.controller;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.community.app.module.bean.ManageModule;
import com.community.app.module.service.ManageModuleService;
import com.community.app.module.vo.BaseBean;
import com.community.app.module.vo.ManageModuleQuery;


@Controller
@RequestMapping("/manage/manageModule")
public class ManageModuleController {
	private static Logger GSLogger = LoggerFactory.getLogger(ManageModuleController.class);
	@Autowired
	private ManageModuleService manageModuleService;
	
	private final String LIST_ACTION = "redirect:/manage/manageModule/list.do";
	
	/**
	 * 进入管理页
	 * @return
	 */
	@RequestMapping(value="enter")
	public ModelAndView enter() {		
		try{
		}catch(Exception e){
			GSLogger.error("进入manageModule管理页时发生错误：/manage/manageModule/enter", e);
			e.printStackTrace();
		}
		ModelAndView mav = new ModelAndView("/manage/manageModule/enter");
		return mav;
	}
	
	/**
	 * 列示或者查询所有数据
	 * @return
	 */
	@RequestMapping(value="list")
	public void list(ManageModuleQuery query, HttpServletResponse response) {
		String json = "";
		StringBuilder result = new StringBuilder();
		try{
			BaseBean baseBean = manageModuleService.findAllPage(query);
			result.append("{\"total\":").append(baseBean.getCount()).append(",")
			.append("\"rows\":[");
			for(int i=0;i<baseBean.getList().size();i++) {
				ManageModule manageModule = (ManageModule) baseBean.getList().get(i);
				result.append("{")
			    .append("\"moduleId\":\"").append(manageModule.getModuleId()).append("\"").append(",")
			    .append("\"moduleName\":\"").append(manageModule.getModuleName()).append("\"").append(",")
			    .append("\"moduleCode\":\"").append(manageModule.getModuleCode()).append("\"").append(",")
			    .append("\"moduleDesc\":\"").append(manageModule.getModuleDesc()).append("\"").append(",")
			    .append("\"moduleIcon\":\"").append(manageModule.getModuleIcon()).append("\"").append(",")
			    .append("\"moduleUrl\":\"").append(manageModule.getModuleUrl()).append("\"").append(",")
			    .append("\"createTime\":\"").append(manageModule.getCreateTime()).append("\"").append(",")
			    .append("\"editTime\":\"").append(manageModule.getEditTime()).append("\"").append(",")
			    .append("\"editor\":\"").append(manageModule.getEditor()).append("\"")
				.append("}").append(",");
			}
			json = result.toString();
			if(baseBean.getList().size() > 0) {
				json = json.substring(0, json.length()-1);
			}
			json += "]}";
			
			response.setHeader("Cache-Control", "no-cache");
			response.setCharacterEncoding("utf-8");
			try {
				response.getWriter().write(json);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}catch(Exception e){
			GSLogger.error("显示manageModule列表时发生错误：/manage/manageModule/list", e);
			e.printStackTrace();
		}
	}
	
	/**
	 * 进入新增页
	 * @return
	 */
	@RequestMapping(value="add")
	public ModelAndView add(ManageModuleQuery query) {		
		try{
		}catch(Exception e){
			GSLogger.error("进入manageModule新增页时发生错误：/manage/manageModule/add", e);
			e.printStackTrace();
		}
		ModelAndView mav = new ModelAndView("/manage/manageModule/add");
		return mav;
	}
	
	/**
	 * 保存对象
	 * @param request
	 * @param manageModule
	 * @return
	 */
	@RequestMapping(value="save")
	public void save(HttpServletRequest request, HttpServletResponse response, ManageModuleQuery query) {
		ManageModule manageModule = new ManageModule();
		String json = "";
		try{
		    manageModule.setModuleName(query.getModuleName());
		    manageModule.setModuleCode(query.getModuleCode());
		    manageModule.setModuleDesc(query.getModuleDesc());
		    manageModule.setModuleIcon(query.getModuleIcon());
		    manageModule.setModuleUrl(query.getModuleUrl());
		    manageModule.setCreateTime(query.getCreateTime());
		    manageModule.setEditTime(query.getEditTime());
		    manageModule.setEditor(query.getEditor());
	        Timestamp  ts=new Timestamp(new Date().getTime());
	        manageModule.setCreateTime(ts);
	        manageModule.setEditTime(ts);
			manageModuleService.save(manageModule);
			//保存成功
			json = "{\"success\":\"true\",\"message\":\"保存成功\"}";
		} catch(Exception e) {
			json = "{\"success\":\"false\",\"message\":\"保存失败\"}";
			GSLogger.error("保存manageModule信息时发生错误：/manage/manageModule/save", e);
			e.printStackTrace();
		}
		response.setHeader("Cache-Control", "no-cache");
		response.setCharacterEncoding("utf-8");
		try {
			response.getWriter().write(json);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	/**
	 * 进入修改页
	 * @return
	 */
	@RequestMapping(value="modify")
	public ModelAndView modify(ManageModuleQuery query) {	
		ManageModule manageModule=new ManageModule();
		
		try{
			manageModule = manageModuleService.findById(query.getModuleId());
		}catch(Exception e){
			GSLogger.error("进入manageModule修改页时发生错误：/manage/manageModule/modify", e);
			e.printStackTrace();
		}
		ModelAndView mav = new ModelAndView("/manage/manageModule/modify");
		mav.addObject("manageModule", manageModule);
		return mav;
	}
	
	/**
	 * 更新对象
	 * @param request
	 * @param query
	 * @return
	 */
	@RequestMapping(value="update")
	public void update(HttpServletRequest request, HttpServletResponse response, ManageModuleQuery query) {
		ManageModule manageModule = null;
		String json = "";
		try{
		    manageModule = manageModuleService.findById(query.getModuleId());
		    manageModule.setModuleName(query.getModuleName());
		    manageModule.setModuleCode(query.getModuleCode());
		    manageModule.setModuleDesc(query.getModuleDesc());
		    manageModule.setModuleIcon(query.getModuleIcon());
		    manageModule.setModuleUrl(query.getModuleUrl());
		    manageModule.setCreateTime(query.getCreateTime());
		    manageModule.setEditTime(query.getEditTime());
		    manageModule.setEditor(query.getEditor());
	        Timestamp  ts=new Timestamp(new Date().getTime());
	        manageModule.setEditTime(ts);
			manageModuleService.update(manageModule);
			
			json = "{\"success\":\"true\",\"message\":\"编辑成功\"}";
		} catch(Exception e) {
			json = "{\"success\":\"false\",\"message\":\"编辑失败\"}";
			GSLogger.error("编辑manageModule信息时发生错误：/manage/manageModule/update", e);
			e.printStackTrace();
		}
		response.setHeader("Cache-Control", "no-cache");
		response.setCharacterEncoding("utf-8");
		try {
			response.getWriter().write(json);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	/**
	 * 删除单个或多个对象
	 * @param id
	 * @return
	 */
	@RequestMapping(value="delete")
	public void delete(@RequestParam(value="id") String id, HttpServletResponse response) {
		String json = "";
		try{
			if(id != null) {
				if(id.indexOf(',') > -1) {
					String[] ids = id.split(",");
					for(int i=0;i<ids.length;i++) {
						manageModuleService.delete(new Integer(ids[i]));
					}
				}else{
					manageModuleService.delete(new Integer(id));
				}
			}
			
			json = "{\"success\":\"true\",\"message\":\"删除成功\"}";
		}catch(Exception e){
			json = "{\"success\":\"false\",\"message\":\"删除失败\"}";
			GSLogger.error("删除ManageModule时发生错误：/manage/manageModule/delete", e);
			e.printStackTrace();
		}
		response.setHeader("Cache-Control", "no-cache");
		response.setCharacterEncoding("utf-8");
		try {
			response.getWriter().write(json);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
}
