package com.yaoxingyu.hotel.dao;

import java.util.List;

import com.yaoxingyu.hotel.model.ManagePermission;

public interface ManagePermissionDao {

	public void insertHotelmanagePermission(ManagePermission managePermission);

	public void updateHotelmanagePermission(ManagePermission managePermission);

	public ManagePermission getByGroupName(String groupName);

	public List<ManagePermission> getByUser(String user);

	public List<ManagePermission> getAll();

	public void deleteById(String id);
}
