package com.zhjy.businessgmp.service;

import java.util.List;

import org.hi.framework.paging.PageInfo;
import com.zhjy.businessgmp.model.VideoManage;
import org.hi.framework.service.Manager;

public interface VideoManageManager extends Manager{
    
    public void saveVideoManage(VideoManage videoManage);

    public void removeVideoManageById(String id);

    public VideoManage getVideoManageById(String id);

    public List<VideoManage> getVideoManageList(PageInfo pageInfo);
    
    public void saveSecurityVideoManage(VideoManage videoManage);

    public void removeSecurityVideoManageById(String id);

    public VideoManage getSecurityVideoManageById(String id);

    public List<VideoManage> getSecurityVideoManageList(PageInfo pageInfo);    
}
