package com.scg.api.Follow;

import com.scg.datadto.TeamMapVo;
import com.scg.model.Common.FollowManage;
import com.scg.persistence.FollowManageMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created by sungbo on 2016-08-08.
 */
@Service
public class FollowService {

    @Autowired
    FollowManageMapper mapper;

    public void saveFollow(FollowManage followManage){
        mapper.saveFollow(followManage);
    };

    public void deleteFollow(FollowManage followManage){
        mapper.deleteFollow(followManage);
    };

    public int getFollowUserCount(FollowManage followManage)
    {
        return mapper.getFollowUserCount(followManage);
    }

    public List<FollowManage> getMeFollowList(FollowManage followManage){
        return mapper.getMeFollowList(followManage);
    };

    public List<TeamMapVo> getFollowerCount(int uid){

        List<TeamMapVo> teamMapVos = mapper.getFollowerCount(uid);

        return teamMapVos;
    };

}
