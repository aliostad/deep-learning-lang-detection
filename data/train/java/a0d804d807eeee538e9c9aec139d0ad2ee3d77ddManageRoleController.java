package org.jgenerator.controller;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.jgenerator.core.util.page.Pager;
import org.jgenerator.model.ManageRole;
import org.jgenerator.model.entityArray.ManageRoleArray;
import org.jgenerator.model.vo.Result;
import org.jgenerator.service.ManageRoleService;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@Scope("request")
public class ManageRoleController {
	public static final String MODULE_PATH = "manage/manageRole/";
	@Resource
	private ManageRoleService manageRoleServiceImpl;

	@RequestMapping(value = "/manage/manageRole/manager")
	public String manager() {
		return MODULE_PATH + "manager";
	}

	@RequestMapping(value = "/manage/manageRole/query")
	@ResponseBody
	public Map<String, Object> query(ManageRole manageRole, 
		Integer page, Integer rows, String orderBy, String sortBy) {
		Pager<ManageRole> pager = manageRoleServiceImpl.queryPage(manageRole,
				page, rows, orderBy, sortBy);
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("total", pager.getTotalCount());
		result.put("rows", pager.getDataList());
		return result;
	}
	
	@RequestMapping(value = "/manage/manageRole/toAdd")
	public String toAdd(){
		return MODULE_PATH + "add";
	}
	
	@RequestMapping(value = "/manage/manageRole/add")
	@ResponseBody
	public Result add(ManageRole manageRole){
		try{
			manageRoleServiceImpl.save(manageRole);
		}catch(Exception e){
			return new Result(Result.ERROR, "角色添加失败！");
		}
		return new Result(Result.SUCCESS, "角色添加成功！");
	}
	
	@RequestMapping(value = "/manage/manageRole/toEdit")
	public String toEdit(Model model, Integer id){
		ManageRole manageRole = manageRoleServiceImpl.fetch(id);
		model.addAttribute("manageRole", manageRole);
		return MODULE_PATH + "edit";
	}
	
	@RequestMapping(value = "/manage/manageRole/edit")
	@ResponseBody
	public Result edit(ManageRole manageRole){
		try{
			manageRoleServiceImpl.saveOrUpdate(manageRole);
		}catch(Exception e){
			return new Result(Result.ERROR, "角色修改失败！");
		}
		return new Result(Result.SUCCESS, "角色修改成功！");
	}
	
	@RequestMapping(value = "/manage/manageRole/deleteByIds")
	@ResponseBody
	public Result deleteByIds(ManageRoleArray array){
		if(null != array && null != array.getManageRoleArray()){
			try{
				for(ManageRole entity : array.getManageRoleArray()){
					manageRoleServiceImpl.delete(entity.getId());
				}
			}catch(Exception e){
				return new Result(Result.ERROR, "角色删除失败！");
			}
		}
		return new Result(Result.SUCCESS, "角色删除成功！");
	}
}