package com.scg.persistence;

import com.scg.datadto.TeamMapVo;
import com.scg.model.Common.FollowManage;

import java.util.List;

/**
 * Created by sungbo on 2016-08-08.
 */
public interface FollowManageMapper {

    public void saveFollow(FollowManage followManage);
    public void deleteFollow(FollowManage followManage);
    public int getFollowUserCount(FollowManage followManage);

    public List<FollowManage> getMeFollowList(FollowManage followManage);

    public List<TeamMapVo> getFollowerCount(int uid);
}
