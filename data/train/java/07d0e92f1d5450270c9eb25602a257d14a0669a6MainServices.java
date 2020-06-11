package com.quantium.web.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Created by Михаил on 20.08.14.
 */
@Service
public class MainServices {

    public static SecurityService securityService;
    @Autowired
    public void setSecurityService(SecurityService securityService){
        MainServices.securityService = securityService;
    }

    public static CoreService coreService;
    @Autowired
    public void setCoreService(CoreService coreService) {
        MainServices.coreService = coreService;
    }

    public static ViewService viewService;
    @Autowired
    public void setViewService(ViewService viewService) {
        MainServices.viewService = viewService;
    }

    public static SocialService socialService;
    @Autowired
    public void setSocialService(SocialService socialService) {
        MainServices.socialService = socialService;
    }

    public static LocationService locationService;
    @Autowired
    public void setLocationService(LocationService locationService) {
        MainServices.locationService = locationService;
    }

    public static MediaService mediaService;
    @Autowired
    public void setMediaService(MediaService mediaService) {
        MainServices.mediaService = mediaService;
    }


}
