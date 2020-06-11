package egovframework.let.uss.olp.qmc.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;
import egovframework.let.uss.olp.qmc.service.QustnrManageVO;
import egovframework.com.cmm.ComDefaultVO;
/**
 * 설문관리를 처리하는 Dao Class 구현
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
 *
 * </pre>
 */ 
@Repository("qustnrManageDao")
public class QustnrManageDao extends EgovAbstractDAO {
	
    /**
	 * 설문템플릿 목록을 조회한다. 
	 * @param qustnrManageVO - 설문관리 정보 담김 VO
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List selectQustnrTmplatManageList(QustnrManageVO qustnrManageVO) throws Exception{
		return (List)list("QustnrManage.selectQustnrTmplatManage", qustnrManageVO);
	}
	
    /**
	 * 설문관리 목록을 조회한다. 
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List selectQustnrManageList(ComDefaultVO searchVO) throws Exception{
		return (List)list("QustnrManage.selectQustnrManage", searchVO);
	}
	
    /**
	 * 설문관리를 상세조회(Model) 한다. 
	 * @param qustnrManageVO - 설문관리 정보 담김 VO
	 * @return List
	 * @throws Exception
	 */
    public QustnrManageVO selectQustnrManageDetailModel(QustnrManageVO qustnrManageVO) throws Exception {    	
        return (QustnrManageVO) selectByPk("QustnrManage.selectQustnrManageDetailModel", qustnrManageVO);
    }
    
    /**
	 * 설문관리를(을) 상세조회 한다.
	 * @param qustnrManageVO - 설문관리 정보 담김 VO
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List selectQustnrManageDetail(QustnrManageVO qustnrManageVO) throws Exception{
		return (List)list("QustnrManage.selectQustnrManageDetail", qustnrManageVO);
	}

    /**
	 * 설문관리를(을) 목록 전체 건수를(을) 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return int
	 * @throws Exception
	 */
	public int selectQustnrManageListCnt(ComDefaultVO searchVO) throws Exception{
		return (Integer)getSqlMapClientTemplate().queryForObject("QustnrManage.selectQustnrManageCnt", searchVO);
	}
	
    /**
	 * 설문관리를(을) 등록한다.
	 * @param qqustnrManageVO - 설문관리 정보 담김 VO
	 * @throws Exception
	 */
	public void insertQustnrManage(QustnrManageVO qustnrManageVO) throws Exception{
		insert("QustnrManage.insertQustnrManage", qustnrManageVO);
	}

    /**
	 * 설문관리를(을) 수정한다.
	 * @param qustnrManageVO - 설문관리 정보 담김 VO
	 * @throws Exception
	 */
	public void updateQustnrManage(QustnrManageVO qustnrManageVO) throws Exception{
		insert("QustnrManage.updateQustnrManage", qustnrManageVO);
	}
	
    /**
	 * 설문관리를(을) 삭제한다.
	 * @param qustnrManageVO - 설문관리 정보 담김 VO
	 * @throws Exception
	 */
	public void deleteQustnrManage(QustnrManageVO qustnrManageVO) throws Exception{
		//설문응답자 삭제
		delete("QustnrManage.deleteQustnrRespondManage", qustnrManageVO);
		//설문조사(설문결과) 삭제
		delete("QustnrManage.deleteQustnrRespondInfo", qustnrManageVO);
		//설문항목 삭제
		delete("QustnrManage.deleteQustnrItemManage", qustnrManageVO);
		//설문문항 삭제
		delete("QustnrManage.deleteQustnrQestnManage", qustnrManageVO);
		
		//설문관리 삭제
		delete("QustnrManage.deleteQustnrManage", qustnrManageVO);
	}
}
