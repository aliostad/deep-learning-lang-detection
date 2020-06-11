package com.hrofirst.controller;

import org.springframework.beans.factory.annotation.Autowired;

import com.hrofirst.service.CityService;
import com.hrofirst.service.NewsService;
import com.hrofirst.service.PolicyService;
import com.hrofirst.service.ProvinceService;
import com.hrofirst.service.WeChatService;
import com.hrofirst.service.WeChatUploadFileService;
import com.hrofirst.service.WebAppMenuService;
import com.service.provider.CenterUserService;
import com.service.provider.ReceivingAddrServiceInterface;

/**
 * Created by qixb.fnst on 2015/02/10.
 */
public class baseController {
    
	@Autowired
    ProvinceService provinceService;
    
    @Autowired
    CityService cityService;
    
    @Autowired
    PolicyService policyService;
    
    @Autowired
    NewsService newsService;

    @Autowired
    WeChatService weChatService;
    
    static int INDEX_NEWS_SIZE = 20;
    
    @Autowired
    WebAppMenuService webappmenuService;
    
    @Autowired
    ReceivingAddrServiceInterface receivingAddrServiceInterface; //收货地址管理接口
	
    @Autowired
    CenterUserService centerUserService; 
    
    @Autowired
    WeChatUploadFileService weChatUploadFileService; 
}
