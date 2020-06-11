package lcn.module.batch.web.common.com.service.impl;

import java.util.List;

import javax.annotation.Resource;

import lcn.module.batch.web.common.com.dao.FtpIntrlManageDAO;
import lcn.module.batch.web.common.com.model.FtpIntrlManage;
import lcn.module.batch.web.common.com.model.FtpIntrlManageVO;
import lcn.module.batch.web.common.com.service.FtpIntrlManageService;
import lcn.module.framework.base.AbstractServiceImpl;

import org.springframework.stereotype.Service;


/**
 * FTP연동관리에 관한 ServiceImpl 클래스
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

@Service("ftpIntrlManageService")
public class FtpIntrlManageServiceImpl extends AbstractServiceImpl implements FtpIntrlManageService {
    
	@Resource(name="ftpIntrlManageDAO")
    private FtpIntrlManageDAO ftpIntrlManageDAO;

    /**
	 *FtpIntrl 목록 조회
	 * @param ftpIntrlManageVO FtpIntrlManageVO
	 * @return List<FtpIntrlManageVO>
	 * @exception Exception
	 */
    public List<FtpIntrlManageVO> selectFtpIntrlList(FtpIntrlManageVO ftpIntrlManageVO) throws Exception {
        return ftpIntrlManageDAO.selectFtpIntrlList(ftpIntrlManageVO);
    }
    
	/**
	 * FtpIntrl 등록
	 * @param ftpIntrlManage FtpIntrlManage
	 * @exception Exception
	 */
    public void insertFtpIntrl(FtpIntrlManage ftpIntrlManage) throws Exception {
    	ftpIntrlManageDAO.insertFtpIntrl(ftpIntrlManage);
    }

    /**
	 * FtpIntrl 수정
	 * @param ftpIntrlManage FtpIntrlManage
	 * @exception Exception
	 */
    public void updateFtpIntrl(FtpIntrlManage ftpIntrlManage) throws Exception {
    	ftpIntrlManageDAO.updateFtpIntrl(ftpIntrlManage);
    }

    /**
	 * FtpIntrl 삭제
	 * @param ftpIntrlManage FtpIntrlManage
	 * @exception Exception
	 */
    public void deleteFtpIntrl(FtpIntrlManage ftpIntrlManage) throws Exception {
    	
    	if(ftpIntrlManage.getFtpIntrlckNo().equals("FTP_0000000000000000")){
    		return;
    	}else if(ftpIntrlManage.getFtpIntrlckNo().equals("FTP_1000000000000000")){
    		return;
    	}else{
    		ftpIntrlManageDAO.deleteFtpIntrl(ftpIntrlManage);
    	}
    	
    }

    /**
	 * FtpIntrl 조회
	 * @param ftpIntrlManageVO FtpIntrlManageVO
	 * @return int
	 * @exception Exception
	 */
    public int selectFtpIntrlListTotCnt(FtpIntrlManageVO ftpIntrlManageVO) throws Exception {
        return ftpIntrlManageDAO.selectFtpIntrlListTotCnt(ftpIntrlManageVO);
    }

    /**
	 * FtpIntrl 조회
	 * @param ftpIntrlManageVO FtpIntrlManageVO
	 * @return FtpIntrlManageVO
	 * @exception Exception
	 */
    public FtpIntrlManageVO selectFtpIntrl(FtpIntrlManageVO ftpIntrlManageVO) throws Exception {
    	FtpIntrlManageVO resultVO = ftpIntrlManageDAO.selectFtpIntrl(ftpIntrlManageVO);
        if (resultVO == null){
        	throw processException("info.nodata.msg");
        }
            
        return resultVO;
    }
//    
//    /**
//	 * 모든 권한목록을 조회한다.
//	 * @param ftpIntrlManageVO FtpIntrlManageVO
//	 * @return List<FtpIntrlManageVO>
//	 * @exception Exception
//	 */
//	public List<FtpIntrlManageVO> selectFtpIntrlAllList(FtpIntrlManageVO ftpIntrlManageVO) throws Exception {
//    	return ftpIntrlManageDAO.selectFtpIntrlAllList(ftpIntrlManageVO);
//    }
}
