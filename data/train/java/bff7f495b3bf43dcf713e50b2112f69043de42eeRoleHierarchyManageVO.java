package lcn.module.oltp.web.common.sec.model;

import java.util.List;

/**
 * 롤 상하관계 관리에 대한 Vo 클래스를 정의한다.
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
 *   2009.03.20  이문준          최초 생성
 *
 * </pre>
 */

public class RoleHierarchyManageVO extends RoleHierarchyManage {
	/**
	 * serialVersionUID
	 */
	private static final long serialVersionUID = 1L;
	/**
	 * 롤 목록
	 */	
	List <RoleHierarchyManageVO> roleHierarchyManageList;


	/**
	 * roleManageList attribute 를 리턴한다.
	 * @return List<RoleManageVO>
	 */
	public List<RoleHierarchyManageVO> getRoleHierarchyManageList() {
		return roleHierarchyManageList;
	}
	/**
	 * roleManageList attribute 값을 설정한다.
	 * @param roleManageList List<RoleManageVO> 
	 */
	public void setRoleHierarchyManageList(List<RoleHierarchyManageVO> roleHierarchyManageList) {
		this.roleHierarchyManageList = roleHierarchyManageList;
	}

	/**
	 * RoleManage 를 리턴한다.
	 * @return RoleManage
	 */
	public RoleHierarchyManage getRoleHierarchyManage() {
		return getRoleHierarchyManage();
	}
	/**
	 * RoleManage 값을 설정한다.
	 * @param roleManage
	 */
	public void setRoleHierarchyManage(RoleHierarchyManage RoleHierarchyManage) {
		setRoleHierarchyManage(RoleHierarchyManage);
	}		
	
}