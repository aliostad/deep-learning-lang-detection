package org.azt.mstore.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("admin")
public class AdminController extends ControllerBase {

	@RequestMapping(value="user-manage", method=RequestMethod.GET)
    private String userManage() {
		return getView("user-manage");
	}
	
	@RequestMapping(value="roles-manage", method=RequestMethod.GET)
	public String rolesManage() {
		return getView("roles-manage");
	}
	
	@RequestMapping(value="authorities-manage", method=RequestMethod.GET)
	public String authoritiesManage() {
		return getView("authorities-manage");
	}
	
	@RequestMapping(value="resources-manage", method=RequestMethod.GET)
	public String resourcesManage() {
		return getView("resources-manage");
	}
}
