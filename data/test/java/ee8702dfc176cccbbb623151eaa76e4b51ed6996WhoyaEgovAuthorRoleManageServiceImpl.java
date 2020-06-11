package whoya.egovframework.com.sec.ram.service.impl;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Service;

import whoya.whoyaDataProcess;
import whoya.whoyaMap;
import whoya.common.Common;
import whoya.egovframework.com.sec.ram.service.WhoyaEgovAuthorRoleManageService;
import egovframework.com.sec.ram.service.AuthorRoleManage;
import egovframework.com.sec.ram.service.AuthorRoleManageVO;
import egovframework.com.sec.ram.service.EgovAuthorRoleManageService;

/**
 * 권한별 롤관리에 대한 ServiceImpl 클래스를 정의한다.
 */

@Service("whoyaEgovAuthorRoleManageService")
public class WhoyaEgovAuthorRoleManageServiceImpl implements WhoyaEgovAuthorRoleManageService {
	
	@Resource(name="egovAuthorRoleManageService")
	EgovAuthorRoleManageService egovAuthorRoleManageService;
	
	/**
	 * 권한 롤 관계정보 목록 조회
	 * @param authorRoleManageVO AuthorRoleManageVO
	 * @return List<AuthorRoleManageVO>
	 * @exception Exception
	 */
	public List<AuthorRoleManageVO> selectAuthorRoleList(AuthorRoleManageVO authorRoleManageVO) throws Exception {
		return egovAuthorRoleManageService.selectAuthorRoleList(authorRoleManageVO);
	}
	
	/**
	 * 권한 롤 관계정보를 화면에서 입력하여 입력항목의 정합성을 체크하고 데이터베이스에 저장
	 * @param request
	 * @param response
	 * @exception Exception
	 */
	public void saveAuthorRole(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String[] ids = request.getParameter("ids").split(",");
		
	    whoyaDataProcess  data = new whoyaDataProcess();
	    whoyaMap rows = new whoyaMap();
	    rows = data.dataProcess(request);
	    
		for (int i = 0; i < ids.length; i++) {
			whoyaMap cols = (whoyaMap) rows.get(ids[i]);
			AuthorRoleManage authorRoleManage = new AuthorRoleManage();
			authorRoleManage = (AuthorRoleManage)Common.convertWhoyaMapToObject(cols, authorRoleManage);
			
			if("Y".equals(authorRoleManage.getRegYn())){
    			egovAuthorRoleManageService.deleteAuthorRole(authorRoleManage);
    			egovAuthorRoleManageService.insertAuthorRole(authorRoleManage);
    		}else {
    			egovAuthorRoleManageService.deleteAuthorRole(authorRoleManage);
    		}
		}
		data.dataRefresh(request, response);
	}
}