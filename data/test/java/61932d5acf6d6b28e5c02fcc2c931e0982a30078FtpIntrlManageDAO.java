package egovframework.bopr.jim.service.impl;

import java.util.List;

import egovframework.bopr.jim.service.FtpIntrlManage;
import egovframework.bopr.jim.service.FtpIntrlManageVO;

import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

import org.springframework.stereotype.Repository;

/**
 * FTP연동관리에 대한 DAO 클래스
 * @ftpIntrl 배치운영환경 김지완
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

@Repository("ftpIntrlManageDAO")
public class FtpIntrlManageDAO extends EgovAbstractDAO {

	 /**
	 * 모든 FtpIntrl 조회
	 * @param ftpIntrlManageVO FtpIntrlManageVO
	 * @return List<FtpIntrlManageVO>
	 * @exception Exception
	 */
    @SuppressWarnings("unchecked")
	public List<FtpIntrlManageVO> selectFtpIntrlList(FtpIntrlManageVO ftpIntrlManageVO) throws Exception {
        return (List<FtpIntrlManageVO>) list("ftpIntrlManageDAO.selectFtpIntrlList", ftpIntrlManageVO);
    }

	/**
	 * FtpIntrl 등록
	 * @param ftpIntrlManage FtpIntrlManage
	 * @exception Exception
	 */
    public void insertFtpIntrl(FtpIntrlManage ftpIntrlManage) throws Exception {
        insert("ftpIntrlManageDAO.insertFtpIntrl", ftpIntrlManage);
    }

    /**
	 * FtpIntrl 수정
	 * @param ftpIntrlManage FtpIntrlManage
	 * @exception Exception
	 */
    public void updateFtpIntrl(FtpIntrlManage ftpIntrlManage) throws Exception {
        update("ftpIntrlManageDAO.updateFtpIntrl", ftpIntrlManage);
    }

    /**
	 * FtpIntrl 삭제
	 * @param ftpIntrlManage FtpIntrlManage
	 * @exception Exception
	 */
    public void deleteFtpIntrl(FtpIntrlManage ftpIntrlManage) throws Exception {
        delete("ftpIntrlManageDAO.deleteFtpIntrl", ftpIntrlManage);
    }

    /**
	 * FtpIntrl 총 갯수 조회
	 * @param ftpIntrlManageVO FtpIntrlManageVO
	 * @return int
	 * @exception Exception
	 */
    public int selectFtpIntrlListTotCnt(FtpIntrlManageVO ftpIntrlManageVO)  throws Exception {
        return (Integer)select("ftpIntrlManageDAO.selectFtpIntrlListTotCnt", ftpIntrlManageVO);
    }

    /**
	 * FtpIntrl 조회
	 * @param ftpIntrlManageVO FtpIntrlManageVO
	 * @return FtpIntrlManageVO
	 * @exception Exception
	 */
    public FtpIntrlManageVO selectFtpIntrl(FtpIntrlManageVO ftpIntrlManageVO) throws Exception {
        return (FtpIntrlManageVO) select("ftpIntrlManageDAO.selectFtpIntrl", ftpIntrlManageVO);
    }
//
//    /**
//	 * 사용자목록을 조회한다.
//	 * @param ftpIntrlManageVO  FtpIntrlManageVO
//	 * @return List<FtpIntrlManageVO>
//	 * @exception Exception
//	 */
//    @SuppressWarnings("unchecked")
//	public List<FtpIntrlManageVO> selectFtpIntrlList(FtpIntrlManageVO ftpIntrlManageVO) throws Exception {
//        return list("ftpIntrlManageDAO.selectFtpIntrlList", ftpIntrlManageVO);
//    }
}
