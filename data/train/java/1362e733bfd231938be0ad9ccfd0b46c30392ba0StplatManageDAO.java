package com.bbm.gps.adm.stplat.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.GpsAbstractDAO;
import com.bbm.gps.adm.stplat.service.StplatManageVO;

/** 
 * 약관관리에 대한 데이터 접근 클래스를 정의한다
 * <p><b>NOTE:</b> 넘어온 요청에 대해 DB작업을 수행하는 메소드들의 집합
 * DB에 직접 접근하며 쿼리문에 적용할 parameter를 보내주거나 단순 쿼리 실행을 하도록 호출한다
 * select, update, delete 함수를 사용하며 쿼리아이디와 parameter를 넘긴다
 * @author 범정부통계포털 이관형 
 * @since 2011.06.27 
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
@Repository("stplatManageDAO")
public class StplatManageDAO extends GpsAbstractDAO {
    
    /**
     * 약관목록조회(stplatManageVO 검색조건에따라 약관목록을 조회)  
     * @param stplatManageVO
     * @return List 조회한 약관목록의 리스트
     * @throws Exception
     * @see stplatSe,stplatSeNm,stplatId,sysId,sysNm,stplatNm,stplatCn,stplatUseSe
     * @see TABLE NAME : TN_STPLAT
     */
    @SuppressWarnings("unchecked")
	public List selectStplatList(StplatManageVO stplatManageVO) throws Exception {
        return list("StplatManageDAO.selectStplatList", stplatManageVO);
    }

    /**
     * 약관목록의 총 갯수
     * @param stplatManageVO
     * @return int 조회한 목록의 리스트
     * @throws Exception
     * @see COUNT(*) totcnt 약관목록 총 갯수
     * @see TABLE NAME : TN_STPLAT
     */
    public int selectStplatListTotCnt(StplatManageVO stplatManageVO) throws Exception {
        return (Integer)getSqlMapClientTemplate().queryForObject("StplatManageDAO.selectStplatListTotCnt", stplatManageVO);
    }

	/**
	 * 약관등록 처리(stplatManageVO에 담겨있는 항목을 DB에 등록) 
	 * @param stplatManageVO
	 * @throws Exception
	 * @see TABLE NAME : TN_STPLAT
	 */
	public void insertStplat(StplatManageVO stplatManageVO) throws Exception {
        insert("StplatManageDAO.insertStplat", stplatManageVO);
	}
	
	/**
	 * 약관목록수정처리
	 * @param stplatManageVO
	 * @throws Exception
	 * @see TABLE NAME : TN_STPLAT
	 */
	public void updateStplat(StplatManageVO stplatManageVO) throws Exception {
        update("StplatManageDAO.updateStplat", stplatManageVO);
	}

	/**
	 * 약관목록 상세
	 * @param stplatManageVO
	 * @return
	 * @throws Exception
	 * @see TABLE NAME : TN_STPLAT
	 */
	public StplatManageVO selectStplat(StplatManageVO stplatManageVO) throws Exception {
		return (StplatManageVO)selectByPk("StplatManageDAO.selectStplat", stplatManageVO);
	}

    /**
     * 약관사용여부수정
     * @param stplatManageVO
     * @throws Exception
     * @see TABLE NAME : TN_STPLAT
     */
    public void updateStplatActvtyAt(StplatManageVO stplatManageVO) throws Exception {
        update("StplatManageDAO.updateStplatActvtyAt", stplatManageVO);
    }
    
	/**
	 * 약관목록 ID에 대한 행삭제(약관삭제) 
	 * @param stplatManageVO
	 * @throws Exception
	 * @see TABLE NAME : TN_STPLAT
	 */
	public void deleteStplat(StplatManageVO stplatManageVO) throws Exception {
		delete("StplatManageDAO.deleteStplat", stplatManageVO);
	}
	
}
