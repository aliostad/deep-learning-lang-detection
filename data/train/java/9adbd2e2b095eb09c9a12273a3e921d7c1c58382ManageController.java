package com.center.platform.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Created by hangu on 2017/1/1.
 */
@Controller
@RequestMapping("/manageService")
public class ManageController extends BaseController {

    @RequestMapping("/userManage")
    public String userCOntroller(){
        return "/manage/user";
    }

    @RequestMapping("/menuManage")
    public String manuManage(){
        return "/manage/menu";
    }
}
