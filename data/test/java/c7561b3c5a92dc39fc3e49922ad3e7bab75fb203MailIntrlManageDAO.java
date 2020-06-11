package lcn.module.batch.web.common.com.dao;

import java.util.List;

import lcn.module.batch.web.common.com.model.MailIntrlManage;
import lcn.module.batch.web.common.com.model.MailIntrlManageVO;
import lcn.module.framework.base.AbstractDAO;

import org.springframework.stereotype.Repository;

 
/**
 * Mail연동관리에 대한 DAO 클래스
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

@Repository("mailIntrlManageDAO")
public class MailIntrlManageDAO extends AbstractDAO {
	
	 /**
	 * 모든 MailIntrl 조회
	 * @param mailIntrlManageVO MailIntrlManageVO
	 * @return List<MailIntrlManageVO>
	 * @exception Exception
	 */
    @SuppressWarnings("unchecked")
	public List<MailIntrlManageVO> selectMailIntrlList(MailIntrlManageVO mailIntrlManageVO) throws Exception {
        return list("mailIntrlManageDAO.selectMailIntrlList", mailIntrlManageVO);
    }    

	/**
	 * MailIntrl 등록
	 * @param mailIntrlManage MailIntrlManage
	 * @exception Exception
	 */
    public void insertMailIntrl(MailIntrlManage mailIntrlManage) throws Exception {
        insert("mailIntrlManageDAO.insertMailIntrl", mailIntrlManage);
    }

    /**
	 * MailIntrl 수정
	 * @param mailIntrlManage MailIntrlManage
	 * @exception Exception
	 */
    public void updateMailIntrl(MailIntrlManage mailIntrlManage) throws Exception {
        update("mailIntrlManageDAO.updateMailIntrl", mailIntrlManage);
    }

    /**
	 * MailIntrl 삭제
	 * @param mailIntrlManage MailIntrlManage
	 * @exception Exception
	 */
    public void deleteMailIntrl(MailIntrlManage mailIntrlManage) throws Exception {
        delete("mailIntrlManageDAO.deleteMailIntrl", mailIntrlManage);
    }
    
    /**
	 * MailIntrl 총 갯수 조회
	 * @param mailIntrlManageVO MailIntrlManageVO
	 * @return int
	 * @exception Exception
	 */
    public int selectMailIntrlListTotCnt(MailIntrlManageVO mailIntrlManageVO)  throws Exception {
        return (Integer)getSqlMapClientTemplate().queryForObject("mailIntrlManageDAO.selectMailIntrlListTotCnt", mailIntrlManageVO);
    }
    
    /**
	 * MailIntrl 조회
	 * @param mailIntrlManageVO MailIntrlManageVO
	 * @return MailIntrlManageVO
	 * @exception Exception
	 */
    public MailIntrlManageVO selectMailIntrl(MailIntrlManageVO mailIntrlManageVO) throws Exception {
        return (MailIntrlManageVO) selectByPk("mailIntrlManageDAO.selectMailIntrl", mailIntrlManageVO);
    }
//    
//    /**
//	 * 사용자목록을 조회한다.
//	 * @param mailIntrlManageVO  MailIntrlManageVO
//	 * @return List<MailIntrlManageVO>
//	 * @exception Exception
//	 */
//    @SuppressWarnings("unchecked")
//	public List<MailIntrlManageVO> selectMailIntrlList(MailIntrlManageVO mailIntrlManageVO) throws Exception {
//        return list("mailIntrlManageDAO.selectMailIntrlList", mailIntrlManageVO);
//    }
}
