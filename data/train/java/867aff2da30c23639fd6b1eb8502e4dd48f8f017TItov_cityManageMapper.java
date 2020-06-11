package com.tmount.db.manage.dao;

import java.util.List;

import com.tmount.db.manage.dto.TItov_city_manage;
import com.tmount.db.manage.dto.TItov_shop4s_manage;

public interface TItov_cityManageMapper {

	List<TItov_city_manage> selectByWhere();
	List<TItov_city_manage> selectCityByWhere(TItov_city_manage tItov_city_manage);
	List<TItov_city_manage> selectCountryByWhere(TItov_city_manage tItov_city_manage);
	List<TItov_city_manage> selectCityByWhereAll();
	List<TItov_city_manage> selectCountryByWhereAll();
}
