package com.chj.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.chj.dao.LocationManageDao;
import com.chj.entity.Area;
import com.chj.service.LocationManage;

@Service
@Transactional
public class LocationManageImpl implements LocationManage {
	@Autowired
	LocationManageDao locationManageDao;
	/**
	 * 查询一级位置管理列表
	 */
	@Override
	public List<Object> findLocationManageList(HashMap<String, Object> manage) {
		return locationManageDao.findLocationManageList(manage);
	}

	@Override
	public Object findLocationManageCount() {
		// TODO Auto-generated method stub
		return locationManageDao.findLocationManageCount();
	}

	@Override
	public Long delLocationmanage(String loctionManageIds) {
		// TODO Auto-generated method stub
		if (loctionManageIds != null && loctionManageIds.trim().length() > 0
				&& !loctionManageIds.equals("")) {
			String[] arry = loctionManageIds.split(",");
			for (int i = 0; i < arry.length; i++) {
				locationManageDao.delLocationmanage(arry[i]);
			}
		}
		return (long) 1;
	}

	@Override
	public List<Object> findLocationManageSubsetList(
			HashMap<String, Object> sublm) {
		// TODO Auto-generated method stub
		return locationManageDao.findLocationManageSubsetList(sublm);
	}

	@Override
	public Object findLocationManageSubsetListCount(
			HashMap<String, Object> sublm) {
		// TODO Auto-generated method stub
		return locationManageDao.findLocationManageSubsetListCount(sublm);
	}

	@Override
	public Long addLocationManageList(Area area) {
		// TODO Auto-generated method stub
		return locationManageDao.addLocationManageList(area);
	}
	/**
	 * 显示一级位置详情
	 */
	@Override
	public Object LocationManageList(String areaid) {
		return locationManageDao.LocationManageList(areaid);
	}

	@Override
	public int updateLoactionManageInfo(Area area) {
		// TODO Auto-generated method stub
		return locationManageDao.updateLoactionManageInfo(area);
	}

	@Override
	public Long addPLocationManageList(Area area) {
		// TODO Auto-generated method stub
		return locationManageDao.addPLocationManageList(area);
	}

	@Override
	public String addLocationManage(String areaId) {
		// TODO Auto-generated method stub
		return locationManageDao.addLocationManage(areaId);
	}

	@Override
	public Object findLoactionManageInfo(String areaId) {
		// TODO Auto-generated method stub
		return locationManageDao.findLoactionManageInfo(areaId);
	}

}
