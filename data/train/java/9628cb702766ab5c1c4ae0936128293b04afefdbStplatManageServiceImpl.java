package com.bbm.gps.adm.stplat.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import com.bbm.gps.adm.stplat.service.StplatManageService;
import com.bbm.gps.adm.stplat.service.StplatManageVO;

/** 
 * 약관관리에 대한 서비스 구현클래스를 정의한다
 * <p><b>NOTE:</b> 서비스에 선언 되어있는 메소드들의 구현 클래스로 데이터 접근 클래스의 메소드를 호출한다
 * 메소드들 중에는 parameter를 넘기는 메소드도 있고 넘기지 않는 메소드도 존재한다
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
 *   2011.06.27     이관형      최초 생성 
 * 
 * </pre> 
 */
@Service("stplatManageService")
public class StplatManageServiceImpl extends AbstractServiceImpl implements StplatManageService {

	/** stplatManageDAO 서비스 호출 */ 
	@Resource(name="stplatManageDAO")
    private StplatManageDAO stplatManageDAO;
    
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
        return stplatManageDAO.selectStplatList(stplatManageVO);
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
        return stplatManageDAO.selectStplatListTotCnt(stplatManageVO);
	}
	
	/**
	 * 약관등록 처리(stplatManageVO에 담겨있는 항목을 DB에 등록) 
	 * @param stplatManageVO
	 * @throws Exception
	 * @see TABLE NAME : TN_STPLAT
	 */
	public void insertStplat(StplatManageVO stplatManageVO) throws Exception {
		stplatManageDAO.insertStplat(stplatManageVO);    	
	}
	
	/**
	 * 약관목록수정처리
	 * @param stplatManageVO
	 * @throws Exception
	 * @see TABLE NAME : TN_STPLAT
	 */
	public void updateStplat(StplatManageVO stplatManageVO) throws Exception {
    	stplatManageDAO.updateStplat(stplatManageVO);    	
	}
	
	/**
	 * 약관목록 상세
	 * @param stplatManageVO
	 * @return StplatManageVO
	 * @throws Exception
	 * @see TABLE NAME : TN_STPLAT
	 */
	public StplatManageVO selectStplat(StplatManageVO stplatManageVO) throws Exception {
    	StplatManageVO ret = (StplatManageVO)stplatManageDAO.selectStplat(stplatManageVO);
    	return ret;
	}
	
	/**
     * 약관사용여부수정
     * @param stplatManageVO
     * @throws Exception
     * @see TABLE NAME : TN_STPLAT
     */
	public void updateStplatActvtyAt(StplatManageVO stplatManageVO) throws Exception {
		stplatManageDAO.updateStplatActvtyAt(stplatManageVO);
	}
	
	/**
	 * 약관목록 ID에 대한 행삭제(약관삭제) 
	 * @param stplatManageVO
	 * @throws Exception
	 * @see TABLE NAME : TN_STPLAT
	 */
	public void deleteStplat(StplatManageVO stplatManageVO) throws Exception {
		stplatManageDAO.deleteStplat(stplatManageVO);
	}
}
