package egovframework.let.uss.olp.qim.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.ComDefaultVO;
import egovframework.let.uss.olp.qim.service.QustnrItemManageVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;
/**
 * 설문항목관리를 처리하는 Dao Class 구현
 * @author 공통서비스 장동한 
 * @since 2009.03.20
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2009.03.20  장동한          최초 생성
 *   2011.08.31  JJY            경량환경 템플릿 커스터마이징버전 생성
 *
 * </pre>
 */
@Repository("qustnrItemManageDao")
public class QustnrItemManageDao extends EgovAbstractDAO {

	
    /**
	 * 설문템플릿(을)를  목록을 조회한다. 
	 * @param qustnrItemManageVO - 설문항목 정보 담김 VO
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List selectQustnrTmplatManageList(QustnrItemManageVO qustnrItemManageVO) throws Exception{
		return (List)list("QustnrItemManage.selectQustnrTmplatManage", qustnrItemManageVO);
	}
	
    /**
	 * 설문항목 목록을 조회한다. 
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List selectQustnrItemManageList(ComDefaultVO searchVO) throws Exception{
		return (List)list("QustnrItemManage.selectQustnrItemManage", searchVO);
	}
	
    /**
	 * 설문항목를(을) 상세조회 한다.
	 * @param qustnrItemManageVO - 설문항목 정보 담김 VO
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List selectQustnrItemManageDetail(QustnrItemManageVO qustnrItemManageVO) throws Exception{
		return (List)list("QustnrItemManage.selectQustnrItemManageDetail", qustnrItemManageVO);
	}

    /**
	 * 설문항목를(을) 목록 전체 건수를(을) 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return int
	 * @throws Exception
	 */
	public int selectQustnrItemManageListCnt(ComDefaultVO searchVO) throws Exception{
		return (Integer)getSqlMapClientTemplate().queryForObject("QustnrItemManage.selectQustnrItemManageCnt", searchVO);
	}
	
    /**
	 * 설문항목를(을) 등록한다.
	 * @param qqustnrItemManageVO - 설문항목 정보 담김 VO
	 * @throws Exception
	 */
	public void insertQustnrItemManage(QustnrItemManageVO qustnrItemManageVO) throws Exception{
		insert("QustnrItemManage.insertQustnrItemManage", qustnrItemManageVO);
	}

    /**
	 * 설문항목를(을) 수정한다.
	 * @param qustnrItemManageVO - 설문항목 정보 담김 VO
	 * @throws Exception
	 */
	public void updateQustnrItemManage(QustnrItemManageVO qustnrItemManageVO) throws Exception{
		insert("QustnrItemManage.updateQustnrItemManage", qustnrItemManageVO);
	}
	
    /**
	 * 설문항목를(을) 삭제한다.
	 * @param qustnrItemManageVO - 설문항목 정보 담김 VO
	 * @throws Exception
	 */
	public void deleteQustnrItemManage(QustnrItemManageVO qustnrItemManageVO) throws Exception{
		//설문조사(설문결과) 삭제
		delete("QustnrItemManage.deleteQustnrRespondInfo", qustnrItemManageVO);
		
		//설문항목 삭제
		insert("QustnrItemManage.deleteQustnrItemManage", qustnrItemManageVO);
		
	}
}
