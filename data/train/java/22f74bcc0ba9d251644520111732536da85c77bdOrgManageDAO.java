package com.bbm.gps.adm.org.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.GpsAbstractDAO;
import com.bbm.gps.adm.org.service.OrgManageVO;

/** 
 * 기관관리에 대한 데이터 접근 클래스를 정의한다
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
 *   2011.05.15     이관형      최초 생성 
 * 
 * </pre> 
 */
@Repository("orgManageDAO")
public class OrgManageDAO extends GpsAbstractDAO {

	/** 
	 * 기관삭제
	 * @param orgManageVO  삭제 항목에 대한 구분자 
	 * @exception Exception 
	 * @see    
	 * @see TABLE NAME :
 	 */ 
	public void deleteOrg(OrgManageVO orgManageVO) throws Exception {
		delete("OrgManageDAO.deleteOrg", orgManageVO);
	}

	/** 
     * 기관 등록
     * @param orgManageVO insert할 항목에 대한 정보를 담고있는 기관VO
     * @exception Exception 
	 * @see    
	 * @see TABLE NAME :
     */ 
	public void insertOrg(OrgManageVO orgManageVO) throws Exception {
        insert("OrgManageDAO.insertOrg", orgManageVO);
	}

	/** 
     * 기관 수정
     * @param orgManageVO 업데이트항목에 대한 기관 정보를 가지고있는VO
     * @exception Exception 
	 * @see    
	 * @see TABLE NAME :
     */ 
	public void updateOrg(OrgManageVO orgManageVO) throws Exception {
        update("OrgManageDAO.updateOrg", orgManageVO);
	}

	/** 
     * 기관정보 출력
     * @return OrgManageVO 상세화면 출력 정보
     * @exception Exception 
	 * @see    
	 * @see TABLE NAME :
     */ 
	public OrgManageVO selectOrg(OrgManageVO orgManageVO) throws Exception {
		return (OrgManageVO)selectByPk("OrgManageDAO.selectOrg", orgManageVO);
	}

	/** 
	 * 기관목록 조회  
	 * @param orgManageVO 검색조건
	 * @return List 조회한 기관목록
	 * @exception Exception 
	 * @see    
	 * @see TABLE NAME :
	 */ 
	@SuppressWarnings("unchecked")
    public List selectOrgList(OrgManageVO orgManageVO) throws Exception {
        return list("OrgManageDAO.selectOrgList", orgManageVO);
    }
	
	/** 
	 * 기관목록의 총 갯수를 조회한다.
	 * @param  orgManageVO
	 * @return int 기관목록의 리스트
	 * @exception Exception 
     * @see COUNT(*) totcnt 
	 * @see TABLE NAME :
	 */ 
    public int selectOrgListTotCnt(OrgManageVO orgManageVO) throws Exception {
        return (Integer)getSqlMapClientTemplate().queryForObject("OrgManageDAO.selectOrgListTotCnt", orgManageVO);
    }

    /** 
     * 기관목록검색 결과에 대한 excel 파일 다운로드 
     * @param orgManageVO
     * @return List 기관목록 정보
     * @exception Exception 
	 * @see 
	 * @see TABLE NAME :
     */ 
	@SuppressWarnings("unchecked")
    public List selectExcelOrgList(OrgManageVO orgManageVO) throws Exception {
        return list("OrgManageDAO.selectExcelList", orgManageVO);
    }
}
