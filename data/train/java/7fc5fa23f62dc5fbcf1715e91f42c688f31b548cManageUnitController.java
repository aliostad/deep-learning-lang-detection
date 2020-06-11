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

import com.community.app.module.bean.ManageUnit;
import com.community.app.module.service.ManageUnitService;
import com.community.app.module.vo.BaseBean;
import com.community.app.module.vo.ManageUnitQuery;


@Controller
@RequestMapping("/manage/manageUnit")
public class ManageUnitController {
	private static Logger GSLogger = LoggerFactory.getLogger(ManageUnitController.class);
	@Autowired
	private ManageUnitService manageUnitService;
	
	private final String LIST_ACTION = "redirect:/manage/manageUnit/list.do";
	
	/**
	 * 进入管理页
	 * @return
	 */
	@RequestMapping(value="enter")
	public ModelAndView enter() {		
		try{
		}catch(Exception e){
			GSLogger.error("进入manageUnit管理页时发生错误：/manage/manageUnit/enter", e);
			e.printStackTrace();
		}
		ModelAndView mav = new ModelAndView("/manage/manageUnit/enter");
		return mav;
	}
	
	/**
	 * 列示或者查询所有数据
	 * @return
	 */
	@RequestMapping(value="list")
	public void list(ManageUnitQuery query, HttpServletResponse response) {
		String json = "";
		StringBuilder result = new StringBuilder();
		try{
			BaseBean baseBean = manageUnitService.findAllPage(query);
			result.append("{\"total\":").append(baseBean.getCount()).append(",")
			.append("\"rows\":[");
			for(int i=0;i<baseBean.getList().size();i++) {
				ManageUnit manageUnit = (ManageUnit) baseBean.getList().get(i);
				result.append("{")
			    .append("\"unitId\":\"").append(manageUnit.getUnitId()).append("\"").append(",")
			    .append("\"buildingId\":\"").append(manageUnit.getBuildingId()).append("\"").append(",")
			    .append("\"unitName\":\"").append(manageUnit.getUnitName()).append("\"").append(",")
			    .append("\"estateLongitude\":\"").append(manageUnit.getEstateLongitude()).append("\"").append(",")
			    .append("\"estateLatitude\":\"").append(manageUnit.getEstateLatitude()).append("\"").append(",")
			    .append("\"createTime\":\"").append(manageUnit.getCreateTime()).append("\"").append(",")
			    .append("\"editTime\":\"").append(manageUnit.getEditTime()).append("\"").append(",")
			    .append("\"editor\":\"").append(manageUnit.getEditor()).append("\"").append(",")
			    .append("\"unitMap\":\"").append(manageUnit.getUnitMap()).append("\"")
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
			GSLogger.error("显示manageUnit列表时发生错误：/manage/manageUnit/list", e);
			e.printStackTrace();
		}
	}
	
	/**
	 * 进入新增页
	 * @return
	 */
	@RequestMapping(value="add")
	public ModelAndView add(ManageUnitQuery query) {		
		try{
		}catch(Exception e){
			GSLogger.error("进入manageUnit新增页时发生错误：/manage/manageUnit/add", e);
			e.printStackTrace();
		}
		ModelAndView mav = new ModelAndView("/manage/manageUnit/add");
		return mav;
	}
	
	/**
	 * 保存对象
	 * @param request
	 * @param manageUnit
	 * @return
	 */
	@RequestMapping(value="save")
	public void save(HttpServletRequest request, HttpServletResponse response, ManageUnitQuery query) {
		ManageUnit manageUnit = new ManageUnit();
		String json = "";
		try{
		    manageUnit.setBuildingId(query.getBuildingId());
		    manageUnit.setUnitName(query.getUnitName());
		    manageUnit.setEstateLongitude(query.getEstateLongitude());
		    manageUnit.setEstateLatitude(query.getEstateLatitude());
		    manageUnit.setCreateTime(query.getCreateTime());
		    manageUnit.setEditTime(query.getEditTime());
		    manageUnit.setEditor(query.getEditor());
		    manageUnit.setUnitMap(query.getUnitMap());
	        Timestamp  ts=new Timestamp(new Date().getTime());
	        manageUnit.setCreateTime(ts);
	        manageUnit.setEditTime(ts);
			manageUnitService.save(manageUnit);
			//保存成功
			json = "{\"success\":\"true\",\"message\":\"保存成功\"}";
		} catch(Exception e) {
			json = "{\"success\":\"false\",\"message\":\"保存失败\"}";
			GSLogger.error("保存manageUnit信息时发生错误：/manage/manageUnit/save", e);
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
	public ModelAndView modify(ManageUnitQuery query) {	
		ManageUnit manageUnit=new ManageUnit();
		
		try{
			manageUnit = manageUnitService.findById(query.getUnitId());
		}catch(Exception e){
			GSLogger.error("进入manageUnit修改页时发生错误：/manage/manageUnit/modify", e);
			e.printStackTrace();
		}
		ModelAndView mav = new ModelAndView("/manage/manageUnit/modify");
		mav.addObject("manageUnit", manageUnit);
		return mav;
	}
	
	/**
	 * 更新对象
	 * @param request
	 * @param query
	 * @return
	 */
	@RequestMapping(value="update")
	public void update(HttpServletRequest request, HttpServletResponse response, ManageUnitQuery query) {
		ManageUnit manageUnit = null;
		String json = "";
		try{
		    manageUnit = manageUnitService.findById(query.getUnitId());
		    manageUnit.setBuildingId(query.getBuildingId());
		    manageUnit.setUnitName(query.getUnitName());
		    manageUnit.setEstateLongitude(query.getEstateLongitude());
		    manageUnit.setEstateLatitude(query.getEstateLatitude());
		    manageUnit.setCreateTime(query.getCreateTime());
		    manageUnit.setEditTime(query.getEditTime());
		    manageUnit.setEditor(query.getEditor());
		    manageUnit.setUnitMap(query.getUnitMap());
	        Timestamp  ts=new Timestamp(new Date().getTime());
	        manageUnit.setEditTime(ts);
			manageUnitService.update(manageUnit);
			
			json = "{\"success\":\"true\",\"message\":\"编辑成功\"}";
		} catch(Exception e) {
			json = "{\"success\":\"false\",\"message\":\"编辑失败\"}";
			GSLogger.error("编辑manageUnit信息时发生错误：/manage/manageUnit/update", e);
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
						manageUnitService.delete(new Integer(ids[i]));
					}
				}else{
					manageUnitService.delete(new Integer(id));
				}
			}
			
			json = "{\"success\":\"true\",\"message\":\"删除成功\"}";
		}catch(Exception e){
			json = "{\"success\":\"false\",\"message\":\"删除失败\"}";
			GSLogger.error("删除ManageUnit时发生错误：/manage/manageUnit/delete", e);
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
