package com.bbm.gps.adm.schedule.service.impl;

import egovframework.rte.psl.dataaccess.GpsAbstractDAO;
import com.bbm.gps.adm.schedule.service.ScheduleManageVO;

import java.util.List;

import org.springframework.stereotype.Repository;

/** 
 * 일정관리에 대한 데이터 접근 클래스를 정의한다
 * <p><b>NOTE:</b> 넘어온 요청에 대해 DB작업을 수행하는 메소드들의 집합
 * DB에 직접 접근하며 쿼리문에 적용할 parameter를 보내주거나 단순 쿼리 실행을 하도록 호출한다
 * select, update, delete 함수를 사용하며 쿼리아이디와 parameter를 넘긴다
 * @author 범정부통계포털 이관형 
 * @since 2011.06.17 
 * @version 1.0 
 * @see 
 * 
 * <pre> 
 *  == Modification Information) == 
 *   
 *     date         author                note 
 *  -----------    --------    --------------------------- 
 *   2011.08.03     이진우      최초 생성
 * 
 * </pre> 
 */
@Repository("scheduleManageDAO")
public class ScheduleManageDAO extends GpsAbstractDAO {
	
    /**
     * scheduleManageVO 일정목록 조회  
     * @param scheduleManageVO
     * @return List
     * @throws Exception
     * @see SC_TY,SC_TY_NM,SC_SN, SUBJECT,ORG_NM, SCHEDULE_CN,START_DT,END_DT,PLACE,STAT_ID,STAT_NM,PHON_CN,FAX_PHON_CN,
     * @see UPDT_DT, REGIST_DT
     * @see TABLE NAME : TN_SCHEDULE
     */
    @SuppressWarnings("unchecked")
	public List selectScheduleList(ScheduleManageVO scheduleManageVO) throws Exception {
        return list("ScheduleManageDAO.selectScheduleList", scheduleManageVO);
    }

    /**
     * scheduleManageVO 일정목록 총 갯수를 조회한다.
     * @param scheduleManageVO
     * @return int
     * @throws Exception
     * @see totcnt 
     * @see TABLE NAME : TN_SCHEDULE
     */
    public int selectScheduleListTotCnt(ScheduleManageVO scheduleManageVO) throws Exception {
        return (Integer)getSqlMapClientTemplate().queryForObject("ScheduleManageDAO.selectScheduleListTotCnt", scheduleManageVO);
    }

	/**
	 * scheduleManageVO 선택된 일정 상세조회  
	 * @param scheduleManageVO
	 * @return ScheduleManageVO
	 * @throws Exception
	 * @see SC_TY,SC_TY_NM,SC_SN, SUBJECT,ORG_NM, SCHEDULE_CN,START_DT,END_DT,PLACE,STAT_ID,STAT_NM,PHON_CN,FAX_PHON_CN,
     * @see UPDT_DT, REGIST_DT
	 * @see TABLE NAME : TN_SCHEDULE
	 */
	public ScheduleManageVO selectSchedule(ScheduleManageVO scheduleManageVO) throws Exception {
		return (ScheduleManageVO)selectByPk("ScheduleManageDAO.selectSchedule", scheduleManageVO);
	}
	
	/**
	 * scheduleManageVO 선택된 일정 삭제 
	 * @param scheduleManageVO
	 * @throws Exception
	 * @see TABLE NAME : TN_SCHEDULE
	 */
	public void deleteSchedule(ScheduleManageVO scheduleManageVO) throws Exception {
		delete("ScheduleManageDAO.deleteSchedule", scheduleManageVO);
	}

	/**
	 * scheduleManageVO VO에 담겨있는 항목을 DB에 insert 
	 * @param scheduleManageVO
	 * @throws Exception
	 * @see TABLE NAME : TN_SCHEDULE
	 */
	public void insertSchedule(ScheduleManageVO scheduleManageVO) throws Exception {
        insert("ScheduleManageDAO.insertSchedule", scheduleManageVO);
	}
	
	/**
	 * scheduleManageVO 수정할 대상 일정을 업데이트 
	 * @param scheduleManageVO
	 * @throws Exception
	 * @see TABLE NAME : TN_SCHEDULE
	 */
	public void updateSchedule(ScheduleManageVO scheduleManageVO) throws Exception {
        update("ScheduleManageDAO.updateSchedule", scheduleManageVO);
	}
	
}
