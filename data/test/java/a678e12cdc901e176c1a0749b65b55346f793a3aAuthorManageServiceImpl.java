package lcn.module.oltp.web.common.sec.service.impl;

import java.util.List;

import javax.annotation.Resource;

import lcn.module.framework.base.AbstractServiceImpl;
import lcn.module.oltp.web.common.sec.dao.AuthorManageDAO;
import lcn.module.oltp.web.common.sec.model.AuthorManage;
import lcn.module.oltp.web.common.sec.model.AuthorManageVO;
import lcn.module.oltp.web.common.sec.service.AuthorManageService;

import org.springframework.stereotype.Service;


/**
 * 권한관리에 관한 ServiceImpl 클래스를 정의한다.
 * @author 공통서비스 개발팀 이문준
 * @since 2009.06.01
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2009.03.11  이문준          최초 생성
 *
 * </pre>
 */

@Service("authorManageService")
public class AuthorManageServiceImpl extends AbstractServiceImpl implements AuthorManageService {
    
	@Resource(name="authorManageDAO")
    private AuthorManageDAO authorManageDAO;

    /**
	 * 권한 목록을 조회한다.
	 * @param authorManageVO AuthorManageVO
	 * @return List<AuthorManageVO>
	 * @exception Exception
	 */
    public List<AuthorManageVO> selectAuthorList(AuthorManageVO authorManageVO) throws Exception {
        return authorManageDAO.selectAuthorList(authorManageVO);
    }
    
	/**
	 * 권한을 등록한다.
	 * @param authorManage AuthorManage
	 * @exception Exception
	 */
    public void insertAuthor(AuthorManage authorManage) throws Exception {
    	authorManageDAO.insertAuthor(authorManage);
    }

    /**
	 * 권한을 수정한다.
	 * @param authorManage AuthorManage
	 * @exception Exception
	 */
    public void updateAuthor(AuthorManage authorManage) throws Exception {
    	authorManageDAO.updateAuthor(authorManage);
    }

    /**
	 * 권한을 삭제한다.
	 * @param authorManage AuthorManage
	 * @exception Exception
	 */
    public void deleteAuthor(AuthorManage authorManage) throws Exception {
    	if(authorManage.getAuthorCode().equals("ROLE_ADMIN")){
    		return;
    	}else{
    		authorManageDAO.deleteAuthor(authorManage);
    	}
    }

    /**
	 * 권한을 조회한다.
	 * @param authorManageVO AuthorManageVO
	 * @return AuthorManageVO
	 * @exception Exception
	 */
    public AuthorManageVO selectAuthor(AuthorManageVO authorManageVO) throws Exception {
    	AuthorManageVO resultVO = authorManageDAO.selectAuthor(authorManageVO);
        if (resultVO == null)
            throw processException("info.nodata.msg");
        return resultVO;
    }

    /**
	 * 권한 목록 카운트를 조회한다.
	 * @param authorManageVO AuthorManageVO
	 * @return int
	 * @exception Exception
	 */
    public int selectAuthorListTotCnt(AuthorManageVO authorManageVO) throws Exception {
        return authorManageDAO.selectAuthorListTotCnt(authorManageVO);
    }    
    
    /**
	 * 모든 권한목록을 조회한다.
	 * @param authorManageVO AuthorManageVO
	 * @return List<AuthorManageVO>
	 * @exception Exception
	 */
	public List<AuthorManageVO> selectAuthorAllList(AuthorManageVO authorManageVO) throws Exception {
    	return authorManageDAO.selectAuthorAllList(authorManageVO);
    }   
	
	/**
     * 입력한 권한코드 중복여부를 체크하여 사용가능여부를 확인
     * @param checkCode 중복체크대상 코드
     * @return int 사용가능여부(코드 사용회수 )
     */
    public int checkCodeDplct(String checkCode)throws Exception{
        return authorManageDAO.checkCodeDplct(checkCode);
    }
}
