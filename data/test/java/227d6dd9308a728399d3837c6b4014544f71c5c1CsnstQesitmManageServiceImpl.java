package com.bbm.gps.adm.csnst.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import com.bbm.gps.adm.csnst.service.CsnstManageVO;
import com.bbm.gps.adm.csnst.service.CsnstQesitmManageService;
 
/** 
 * 만족도조사 문항 관리에 대한 서비스 구현클래스를 정의한다
 * <p><b>NOTE:</b> 만족도 조사 문항 관리서비스에 선언 되어있는 메소드들의 구현 클래스로 프로그램관리테이블 데이터 접근 클래스의 메소드를 호출한다
 * 메소드들 중에는 parameter를 넘기는 메소드도 있고 넘기지 않는 메소드도 존재한다
 * @author 포탈통계 이관형 
 * @since 2011.10.21 
 * @version 1.0 
 * @see 
 * 
 * <pre> 
 *  == Modification Information) == 
 *   
 *     date         author                note 
 *  -----------    --------    --------------------------- 
 *   2011.10.21     이관형      최초 생성 
 * 
 * </pre> 
 */
@Service("csnstQesitmManageService")
public class CsnstQesitmManageServiceImpl extends AbstractServiceImpl implements CsnstQesitmManageService {

	/** csnstQesitmManageDAO 서비스 호출 */ 
	@Resource(name="csnstQesitmManageDAO")
    private CsnstQesitmManageDAO csnstQesitmManageDAO;

	/**
	 * 만족도 조사 문항 삭제
	 * @param csnstManageVO CsnstManageVO
	 * @throws Exception
	 * @see TABLE NAME : TN_CSNST_QESITM_MANAGE
	 */
	public void deleteCsnstQesitm(CsnstManageVO csnstManageVO) throws Exception {
		csnstQesitmManageDAO.deleteCsnstQesitm(csnstManageVO);
	}

	/**
	 * 만족도 조사 문항 등록
	 * @param csnstManageVO CsnstManageVO
	 * @throws Exception
	 * @see TABLE NAME : TN_CSNST_QESITM_MANAGE
	 */
	public void insertCsnstQesitm(CsnstManageVO csnstManageVO) throws Exception {
    	csnstQesitmManageDAO.insertCsnstQesitm(csnstManageVO);    	
	}

	/**
	 * 만족도 조사 문항 수정
	 * @param csnstManageVO CsnstManageVO
	 * @throws Exception
	 * @see TABLE NAME : TN_CSNST_QESITM_MANAGE
	 */
	public void updateCsnstQesitm(CsnstManageVO csnstManageVO) throws Exception {
    	csnstQesitmManageDAO.updateCsnstQesitm(csnstManageVO);    	
	}

	/**
	 * 만족도 조사 문항 수정
	 * @param csnstManageVO CsnstManageVO
	 * @throws Exception
	 * @see SYS_ID, CSNST_ID, CSNST_SN, QESITM_SN, QESITM_QESTN_NM, QESITM_TY, QESITM_QESTN_CO
	 * @see REGIST_DT, REGISTER_ID, REGISTER_IP, UPDT_DT, UPDTUSR_ID
	 * @see TABLE NAME : TN_CSNST_QESITM_MANAGE
	 */
	public CsnstManageVO selectCsnstQesitm(CsnstManageVO csnstManageVO) throws Exception {
    	CsnstManageVO ret = (CsnstManageVO)csnstQesitmManageDAO.selectCsnstQesitm(csnstManageVO);
    	return ret;
	}

	/**
	 * 만족도 조사 문항 일련번호 생성
	 * @throws Exception
	 * @see INT
	 * @see TABLE NAME : TN_CSNST_QESITM_MANAGE
	 */
	public int csnstQesitmSnGeneration() throws Exception {
		return csnstQesitmManageDAO.csnstQesitmSnGeneration();
	}
}
