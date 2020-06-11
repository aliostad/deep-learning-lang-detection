package egovframework.bopr.jim.service.impl;

import java.util.List;

import egovframework.bopr.jim.service.EgovMailIntrlManageService;
import egovframework.bopr.jim.service.MailIntrlManage;
import egovframework.bopr.jim.service.MailIntrlManageVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

/**
 * Mail연동관리에 관한 ServiceImpl 클래스
 * @mailIntrl 배치운영환경 김지완
 * @since 2012.07.16
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2012.07.16  김지완          최초 생성
 *
 * </pre>
 */

@Service("egovMailIntrlManageService")
public class EgovMailIntrlManageServiceImpl extends EgovAbstractServiceImpl implements EgovMailIntrlManageService {
    
	@Resource(name="mailIntrlManageDAO")
    private MailIntrlManageDAO mailIntrlManageDAO;

    /**
	 *MailIntrl 목록 조회
	 * @param mailIntrlManageVO MailIntrlManageVO
	 * @return List<MailIntrlManageVO>
	 * @exception Exception
	 */
    public List<MailIntrlManageVO> selectMailIntrlList(MailIntrlManageVO mailIntrlManageVO) throws Exception {
        return mailIntrlManageDAO.selectMailIntrlList(mailIntrlManageVO);
    }
    
	/**
	 * MailIntrl 등록
	 * @param mailIntrlManage MailIntrlManage
	 * @exception Exception
	 */
    public void insertMailIntrl(MailIntrlManage mailIntrlManage) throws Exception {
    	mailIntrlManageDAO.insertMailIntrl(mailIntrlManage);
    }

    /**
	 * MailIntrl 수정
	 * @param mailIntrlManage MailIntrlManage
	 * @exception Exception
	 */
    public void updateMailIntrl(MailIntrlManage mailIntrlManage) throws Exception {
    	mailIntrlManageDAO.updateMailIntrl(mailIntrlManage);
    }

    /**
	 * MailIntrl 삭제
	 * @param mailIntrlManage MailIntrlManage
	 * @exception Exception
	 */
    public void deleteMailIntrl(MailIntrlManage mailIntrlManage) throws Exception {
    	mailIntrlManageDAO.deleteMailIntrl(mailIntrlManage);
    }

    /**
	 * MailIntrl 조회
	 * @param mailIntrlManageVO MailIntrlManageVO
	 * @return int
	 * @exception Exception
	 */
    public int selectMailIntrlListTotCnt(MailIntrlManageVO mailIntrlManageVO) throws Exception {
        return mailIntrlManageDAO.selectMailIntrlListTotCnt(mailIntrlManageVO);
    }

    /**
	 * MailIntrl 조회
	 * @param mailIntrlManageVO MailIntrlManageVO
	 * @return MailIntrlManageVO
	 * @exception Exception
	 */
    public MailIntrlManageVO selectMailIntrl(MailIntrlManageVO mailIntrlManageVO) throws Exception {
    	MailIntrlManageVO resultVO = mailIntrlManageDAO.selectMailIntrl(mailIntrlManageVO);
        if (resultVO == null){
        	throw processException("info.nodata.msg");
        }
            
        return resultVO;
    }
//    
//    /**
//	 * 모든 권한목록을 조회한다.
//	 * @param mailIntrlManageVO MailIntrlManageVO
//	 * @return List<MailIntrlManageVO>
//	 * @exception Exception
//	 */
//	public List<MailIntrlManageVO> selectMailIntrlAllList(MailIntrlManageVO mailIntrlManageVO) throws Exception {
//    	return mailIntrlManageDAO.selectMailIntrlAllList(mailIntrlManageVO);
//    }
}
