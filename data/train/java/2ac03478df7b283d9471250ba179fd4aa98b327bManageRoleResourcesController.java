package org.jgenerator.controller;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.jgenerator.core.util.page.Pager;
import org.jgenerator.model.ManageRoleResources;
import org.jgenerator.model.Resources;
import org.jgenerator.model.entityArray.ManageRoleResourcesArray;
import org.jgenerator.service.ManageRoleResourcesService;
import org.jgenerator.service.ResourcesService;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@Scope("request")
public class ManageRoleResourcesController {
	public static final String MODULE_PATH = "manage/manageRoleResources/";
	@Resource
	private ManageRoleResourcesService manageRoleResourcesServiceImpl;
	@Resource
	private ResourcesService resourcesService;

	@RequestMapping(value = "/manage/manageRoleResources/manager")
	public String manager() {
		return MODULE_PATH + "manager";
	}

	@RequestMapping(value = "/manage/manageRoleResources/query")
	public String query(ManageRoleResources manageRoleResources, 
		Integer page, Integer rows, String orderBy, String sortBy, Model model) {
		if(null == manageRoleResources){
			return MODULE_PATH + "resourceList";
		}
		List<Resources> resourceList = resourcesService.findAll();
		Map<String, Object> params = manageRoleResources.toHashMap();
		params.put("manageRoleId", manageRoleResources.getManageRoleId());
		Pager<ManageRoleResources> pager = manageRoleResourcesServiceImpl.queryPage(params, 1, Integer.MAX_VALUE);

		if (null != pager.getDataList() && pager.getDataList().size() > 0) {
			for (ManageRoleResources mr : pager.getDataList()) {
				Resources r = new Resources();
				r.setId(mr.getResourceId());
				for(Resources rs : resourceList){
					if(rs.equals(r)){
						rs.setAttribute5("1");
						continue;
					}
				}
			}
		}
		model.addAttribute("list", resourceList);
		return MODULE_PATH + "resourceList";
	}
	
	@RequestMapping(value = "/manage/manageRoleResources/toAdd")
	public String toAdd(){
		return MODULE_PATH + "add";
	}
	
	@RequestMapping(value = "/manage/manageRoleResources/add")
	@ResponseBody
	public String add(ManageRoleResourcesArray manageRoleResourcesArray, Integer roleId) {
		Map<String, Object> condition = new HashMap<String, Object>();
		if (null != roleId) {
			condition.put("manageRoleId", roleId);
		} else {
			condition.put("manageRoleId", manageRoleResourcesArray
					.getManageRoleResourcesArray().get(0).getManageRoleId());
		}
		manageRoleResourcesServiceImpl.deleteByCondition(condition);
		if (null != manageRoleResourcesArray.getManageRoleResourcesArray()
				&& manageRoleResourcesArray.getManageRoleResourcesArray()
						.size() > 0) {
			for (ManageRoleResources m : manageRoleResourcesArray
					.getManageRoleResourcesArray()) {
				manageRoleResourcesServiceImpl.save(m);
			}
		}
		return "1";
	}
	
	@RequestMapping(value = "/manage/manageRoleResources/toEdit")
	public String toEdit(Model model, Integer id){
		ManageRoleResources manageRoleResources = manageRoleResourcesServiceImpl.fetch(id);
		model.addAttribute("manageRoleResources", manageRoleResources);
		return MODULE_PATH + "edit";
	}
	
	@RequestMapping(value = "/manage/manageRoleResources/edit")
	@ResponseBody
	public String edit(ManageRoleResources manageRoleResources){
		manageRoleResourcesServiceImpl.saveOrUpdate(manageRoleResources);
		return "1";
	}
	
	@RequestMapping(value = "/manage/manageRoleResources/deleteByIds")
	@ResponseBody
	public String deleteByIds(ManageRoleResourcesArray array){
		if(null != array && null != array.getManageRoleResourcesArray()){
			for(ManageRoleResources entity : array.getManageRoleResourcesArray()){
				manageRoleResourcesServiceImpl.delete(entity.getId());
			}
		}
		return "1";
	}
}