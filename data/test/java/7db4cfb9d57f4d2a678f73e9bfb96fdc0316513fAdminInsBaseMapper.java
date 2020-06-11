package com.base.mapper.base;

import com.base.model.HolidayCommon;
import com.base.model.HolidayManage;
import com.base.model.UserAnnualInfo;


public interface AdminInsBaseMapper {
	// 등록
	void insertHolidayManage(HolidayManage holidayManage);
	void insertHolidayManageList(HolidayManage holidayManage);
	void insertUserAnnualInfo(UserAnnualInfo userAnnualInfo);

	void insertHolidayCommon(HolidayCommon hCommon);
	
	// 삭제
	void deleteHolidayManage(HolidayManage holidayManage);
	void deleteHolidayManageList(HolidayManage holidayManage);
	
	// 수정
	void updateHolidayCommon(HolidayCommon hCommon);
}